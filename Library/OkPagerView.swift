//
//  OkPagerView.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 20/2/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public protocol OkPagerViewDataSource {
    
    func viewControllerAtIndex(index: Int) -> UIViewController?
    func numberOfPages() -> Int?
}

public protocol OkPagerViewDelegate {
    
    func onPageSelected(viewController: UIViewController, index: Int)
}

public class OkPagerView: UIView, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var pageViewController: UIPageViewController!
    public private(set) var currentIndex = 0
    
    public var callFirstItemOnCreated = true
    public var dataSource: OkPagerViewDataSource! {
        didSet {
            reloadData()
        }
    }
    public var delegate: OkPagerViewDelegate!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addPagerViewController()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addPagerViewController()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        addPagerViewController()
    }
    
    // MARK: - Private methods
    private func addPagerViewController() {
        
        if pageViewController != nil {
            return
        }
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.view.frame = self.bounds
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addSubview(pageViewController.view)
        
        let constTop = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: pageViewController.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let constBottom = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: pageViewController.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        let constLeft = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: pageViewController.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        let constRight = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: pageViewController.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        self.addConstraints([constTop, constBottom, constLeft, constRight])
        
        pageControl?.currentPage = 0
    }
    
    private func getViewControllerAtIndex(index: Int) -> PageViewWrapper? {
        if (getNumberOfPages() == 0
            || index >= getNumberOfPages())
        {
            return nil
        }
        
        // Create a new View Controller and pass suitable data.
        guard let wrappedViewController = dataSource.viewControllerAtIndex(index) else {
            return nil
        }
        
        let viewController = PageViewWrapper()
        viewController.wrappedViewController = wrappedViewController
        viewController.pageIndex = index
        return viewController
    }
    
    private func getNumberOfPages() -> Int {
        if let dataSource = dataSource,
            numberOfPages = dataSource.numberOfPages()
            where pageViewController != nil {
                return numberOfPages
        }
        return 0
    }
    
    // MARK: - Public methods
    public func reloadData() {
        
        if getNumberOfPages() > 0
            && currentIndex >= 0
            && currentIndex < getNumberOfPages() {
                self.pageViewController.setViewControllers(
                    [getViewControllerAtIndex(currentIndex)!],
                    direction: UIPageViewControllerNavigationDirection.Forward,
                    animated: false,
                    completion: nil)
                
                pageControl?.currentPage = currentIndex
                
                if callFirstItemOnCreated {
                    delegate?.onPageSelected(getViewControllerAtIndex(currentIndex)!, index: currentIndex)
                }
        }
    }
    
    public func setCurrentIndex(index: Int, animated: Bool) {
        if index == currentIndex {
            print("Same page")
            return
        }
        if index >= getNumberOfPages() {
            print("Trying to reach an unknown page")
            return
        }
        
        let direction: UIPageViewControllerNavigationDirection = currentIndex < index ? .Forward : .Reverse
        
        guard let viewController = getViewControllerAtIndex(index) else {
            print("Method getViewControllerAtIndex(\(index)) is returning nil")
            return
        }
        self.pageViewController.setViewControllers([viewController], direction: direction, animated: animated, completion: nil)
        
        currentIndex = index
        delegate?.onPageSelected(viewController, index: index)
    }
    
    public func setScrollEnabled(enabled: Bool) {
        
        if let pageViewController = pageViewController {
            
            for view in pageViewController.view.subviews {
                if let scrollView = view as? UIScrollView {
                    scrollView.scrollEnabled = enabled
                }
            }
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let itemViewController = viewController as? PageViewWrapper {
            var index = itemViewController.pageIndex
            if (index == 0) || (index == NSNotFound) { return nil }
            index--
            return getViewControllerAtIndex(index)
        }
        return nil
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let itemViewController = viewController as? PageViewWrapper {
            var index = itemViewController.pageIndex
            if index == NSNotFound { return nil }
            index++
            if (index == getNumberOfPages()) { return nil }
            return getViewControllerAtIndex(index)
        }
        return nil
    }
    
    // MARK: - UIPageViewControllerDelegate
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let pageVC = pageViewController.viewControllers!.last as? PageViewWrapper {
                if let delegate = delegate {
                    delegate.onPageSelected(pageVC.wrappedViewController, index: pageVC.pageIndex)
                }
                // Save currentIndex
                currentIndex = pageVC.pageIndex
                pageControl?.currentPage = currentIndex
            }
        }
    }
}

// MARK: - PageViewWrapper
private class PageViewWrapper: UIViewController {
    
    var pageIndex: Int = 0
    var wrappedViewController: UIViewController!
    
    private override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentBounds = self.parentViewController?.view.bounds {
            self.view.frame = parentBounds
        }
        
        wrappedViewController.view.frame = self.view.frame
        let topConstraint = NSLayoutConstraint(item: wrappedViewController.view, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: wrappedViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: wrappedViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: wrappedViewController.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0)
        
        self.view.addSubview(wrappedViewController.view)
        self.view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    // MARK: Life cycle
    private override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        wrappedViewController.viewDidAppear(animated)
    }
    
    private override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        wrappedViewController.viewWillAppear(animated)
    }
    
    private override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        wrappedViewController.viewWillDisappear(animated)
    }
    
    private override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        wrappedViewController.viewDidDisappear(animated)
    }
}