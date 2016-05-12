//
//  PagerViewController.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 5/12/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

class PagerViewController: UIViewController, OkPagerViewDataSource, OkPagerViewDelegate {
    
    @IBOutlet weak var pagerView: OkPagerView!
    
    var pageViews: [SinglePageViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPages()
        setUpPager()
    }
    
    // MARK: - Private methods
    private func setUpPages() {
        pageViews = [SinglePageViewController]()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        for _ in 0..<3 {
            let singlePageVC = storyboard.instantiateViewControllerWithIdentifier(String(SinglePageViewController)) as! SinglePageViewController
            pageViews.append(singlePageVC)
        }
    }
    
    private func setUpPager() {
        pagerView.delegate = self
        pagerView.dataSource = self
    }
    
    // MARK: - OkPagerViewDataSource
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        let singlePageVC = pageViews[index]
        singlePageVC.pageIndex = index
        return singlePageVC
    }
    
    func numberOfPages() -> Int? {
        return pageViews?.count
    }
    
    // MARK: - OkPagerViewDelegate
    func onPageSelected(viewController: UIViewController, index: Int) {
        print("Page selected: \(index)")
    }
    
    // MARK: - Actions
    @IBAction func changePageButtonPressed(sender: UIButton) {
        let currentIndex = pagerView.currentIndex
        let nextPageIndex = currentIndex == pageViews.count - 1 ? 0 : currentIndex + 1
        pagerView.setCurrentIndex(nextPageIndex, animated: true)
    }
    
}
