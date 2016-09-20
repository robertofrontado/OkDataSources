//
//  PagerViewController.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 5/12/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

class PagerViewController: UIViewController, OkPagerViewDataSource, OkPagerViewDelegate, OkSlidingTabsDataSource, OkSlidingTabsDelegate {
    
    @IBOutlet weak var pagerView: OkPagerView!
    @IBOutlet weak var slidingTabs: OkSlidingTabs!
    
    var pageViews: [SinglePageViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPages()
        setUpPager()
        setUpSlidingTabs()
    }
    
    // MARK: - Private methods
    private func setUpPages() {
        pageViews = [SinglePageViewController]()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        for i in 0..<10 {
            let singlePageVC = storyboard.instantiateViewController(withIdentifier: String(describing: SinglePageViewController.self)) as! SinglePageViewController
            singlePageVC.pageIndex = i
            pageViews.append(singlePageVC)
        }
    }
    
    private func setUpPager() {
        pagerView.delegate = self
        pagerView.dataSource = self
    }
    
    private func setUpSlidingTabs() {
        slidingTabs.dataSource = self
        slidingTabs.delegate = self
        slidingTabs.reloadData()
    }
    
    // MARK: - OkPagerViewDataSource
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        return pageViews[index]
    }
    
    func numberOfPages() -> Int? {
        return pageViews?.count
    }
    
    // MARK: - OkPagerViewDelegate
    func onPageSelected(_ viewController: UIViewController, index: Int) {
        print("Page selected: \(index)")
        slidingTabs.setCurrentTab(index)
    }
    
    // MARK: - OkSlidingTabsDataSource
    func titleAtIndex(_ index: Int) -> String {
        return "Page \(index)"
    }
    
    func numberOfTabs() -> Int {
        return pageViews.count
    }

    // MARK: - OkSlidingTabsDelegate
    func onTabSelected(_ index: Int) {
        pagerView.setCurrentIndex(index, animated: true)
    }
    
}
