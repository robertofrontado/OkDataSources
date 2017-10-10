//
//  OkPagerView.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 20/2/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public protocol OkPagerViewDataSource: class {

  func viewControllerAtIndex(_ index: Int) -> UIViewController?
  func numberOfPages() -> Int?
}

public protocol OkPagerViewDelegate: class {

  func onPageSelected(_ viewController: UIViewController, index: Int)
}

open class OkPagerView: UIView, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

  @IBOutlet var pageControl: UIPageControl?

  fileprivate var pageViewController: UIPageViewController!
  open fileprivate(set) var currentIndex = 0

  open var callFirstItemOnCreated = true
  open weak var dataSource: OkPagerViewDataSource! {
    didSet {
      reloadData()
    }
  }
  open weak var delegate: OkPagerViewDelegate!

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addPagerViewController()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    addPagerViewController()
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    addPagerViewController()
  }

  // MARK: - Private methods
  fileprivate func addPagerViewController() {

    if pageViewController != nil {
      return
    }

    pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    pageViewController.dataSource = self
    pageViewController.delegate = self
    self.parentViewController?.addChildViewController(pageViewController)
    addPagerView(pageViewController.view)
    pageViewController.didMove(toParentViewController: self.parentViewController)
    pageControl?.currentPage = 0
  }

  fileprivate func addPagerView(_ pagerView: UIView) {
    pagerView.frame = self.bounds
    self.addSubview(pagerView)

    let constTop = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: pagerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)

    let constBottom = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: pagerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)

    let constLeft = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: pagerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)

    let constRight = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: pagerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)

    self.addConstraints([constTop, constBottom, constLeft, constRight])
  }

  fileprivate func getViewControllerAtIndex(_ index: Int) -> UIViewController? {
    if (getNumberOfPages() == 0
      || index >= getNumberOfPages())
    {
      return nil
    }

    // Create a new View Controller and pass suitable data.
    guard let viewController = dataSource.viewControllerAtIndex(index) else {
      return nil
    }

    viewController.view.tag = index
    return viewController
  }

  fileprivate func getNumberOfPages() -> Int {
    if let dataSource = dataSource,
      let numberOfPages = dataSource.numberOfPages()
      , pageViewController != nil {
      return numberOfPages
    }
    return 0
  }

  // MARK: - Public methods
  open func reloadData() {

    if getNumberOfPages() > 0
      && currentIndex >= 0
      && currentIndex < getNumberOfPages() {
      self.pageViewController.setViewControllers(
        [getViewControllerAtIndex(currentIndex)!],
        direction: UIPageViewControllerNavigationDirection.forward,
        animated: false,
        completion: nil)

      pageControl?.currentPage = currentIndex

      if callFirstItemOnCreated {
        delegate?.onPageSelected(getViewControllerAtIndex(currentIndex)!, index: currentIndex)
      }
    }
  }

  open func setCurrentIndex(_ index: Int, animated: Bool) {
    if index == currentIndex {
      print("Same page")
      return
    }
    if index >= getNumberOfPages() {
      print("Trying to reach an unknown page")
      return
    }

    let direction: UIPageViewControllerNavigationDirection = currentIndex < index ? .forward : .reverse

    guard let viewController = getViewControllerAtIndex(index) else {
      print("Method getViewControllerAtIndex(\(index)) is returning nil")
      return
    }
    self.pageViewController.setViewControllers([viewController], direction: direction, animated: animated, completion: nil)

    currentIndex = index
    delegate?.onPageSelected(viewController, index: index)
  }

  open func setScrollEnabled(_ enabled: Bool) {

    if let pageViewController = pageViewController {

      for view in pageViewController.view.subviews {
        if let scrollView = view as? UIScrollView {
          scrollView.isScrollEnabled = enabled
        }
      }
    }
  }

  // MARK: - UIPageViewControllerDataSource
  open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    var index = viewController.view.tag
    if (index == 0) || (index == NSNotFound) { return nil }
    index -= 1
    return getViewControllerAtIndex(index)
  }

  open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    var index = viewController.view.tag
    if index == NSNotFound { return nil }
    index += 1
    if (index == getNumberOfPages()) { return nil }
    return getViewControllerAtIndex(index)
  }

  // MARK: - UIPageViewControllerDelegate
  open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      if let pageVC = pageViewController.viewControllers!.last as? UIViewController {
        if let delegate = delegate {
          delegate.onPageSelected(pageVC, index: pageVC.view.tag)
        }
        // Save currentIndex
        currentIndex = pageVC.view.tag
        pageControl?.currentPage = currentIndex
      }
    }
  }
}

fileprivate extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
      parentResponder = parentResponder?.next
      if let viewController = parentResponder as? UIViewController {
        return viewController
      }
    }
    return nil
  }
}
