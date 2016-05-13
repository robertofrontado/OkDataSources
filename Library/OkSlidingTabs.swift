//
//  OkSlidingTabs.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 3/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

@objc public protocol OkSlidingTabsDataSource {
    @objc func numberOfTabs() -> Int
    @objc func titleAtIndex(index: Int) -> String
}

@objc public protocol OkSlidingTabsDelegate {
    @objc func onTabSelected(index: Int)
}

@IBDesignable
@objc public class OkSlidingTabs: UIView {

    private var scrollView: UIScrollView!
    private var indicatorView: UIView!
    private var tabs: UILabel!
    private var xOffset: CGFloat = 0
    private var currentTabSelected = 0
    private var labels: [UILabel]!
    
    @IBInspectable
    public var xPadding: CGFloat = 20
    @IBInspectable
    public var xMargin: CGFloat = 0
    @IBInspectable
    public var labelTextColor: UIColor = UIColor.blackColor()
    @IBInspectable
    public var labelBgColor: UIColor = UIColor.whiteColor()
    @IBInspectable
    public var indicatorColor: UIColor = UIColor.blackColor()
    @IBInspectable
    public var indicatorHeight: CGFloat = 5
    @IBInspectable
    public var distributeEvenly: Bool = false {
        didSet {
            reloadData()
        }
    }
    public var font: UIFont = UIFont.systemFontOfSize(14)
    
    public var dataSource: OkSlidingTabsDataSource!
    public var delegate: OkSlidingTabsDelegate!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    // MARK: - Private methods
    private func initView() {
        addScrollView()
        addIndicatorView()
    }
    
    private func addScrollView() {
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.scrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
    }
    
    private func addIndicatorView() {
        if let firstLabelFrame = labels?.first?.frame {
            indicatorView?.removeFromSuperview()
            indicatorView = UIView(frame: CGRectMake(0, CGRectGetHeight(firstLabelFrame) - indicatorHeight, CGRectGetWidth(firstLabelFrame), indicatorHeight))
            indicatorView.backgroundColor = indicatorColor
            scrollView.addSubview(indicatorView)
        }
    }
    
    private func addTabsView() {
        if let dataSource = dataSource {
            if dataSource.numberOfTabs() > 0 {
                labels?.map { $0.removeFromSuperview() }
                labels = []
                for i in 0..<dataSource.numberOfTabs() {
                    // Label
                    let label = UILabel()
                    label.text = dataSource.titleAtIndex(i)
                    label.backgroundColor = labelBgColor
                    label.font = font
                    label.textAlignment = .Center
                    label.textColor = labelTextColor
                    label.sizeToFit()
                    if distributeEvenly {
                        let screenSize = UIScreen.mainScreen().bounds
                        let width = screenSize.width / CGFloat(dataSource.numberOfTabs())
                        label.frame = CGRectMake(xOffset, 0, width, self.frame.height)
                    } else {
                        label.frame = CGRectMake(xOffset, 0, label.frame.width + xPadding, self.frame.height)
                    }
                    scrollView.contentSize = CGSizeMake(xOffset + label.frame.width, self.frame.height)
                    scrollView.addSubview(label)
                    labels.append(label)
                    // Button
                    let button = UIButton(frame: label.frame)
                    button.tag = i
                    button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
                    scrollView.addSubview(button)
                    xOffset += label.frame.width + xMargin
                }
            }
        }
        layoutIfNeeded()
        scrollView.frame = self.bounds
    }
    
    internal func buttonPressed(sender: UIButton) {
        currentTabSelected = sender.tag
        delegate?.onTabSelected(currentTabSelected)
        animateIndicator(currentTabSelected)
    }
    
    // MARK: - Indicator view animations
    private func animateIndicator(index: Int) {
        
        if !(labels != nil && labels.count > 0 && labels.count > index) {
            return
        }
        let labelFrame = labels[index].frame
        UIView.animateWithDuration(0.3) { () -> Void in
            // Indicator animation
            let indicatorFrame = self.indicatorView.frame
            self.indicatorView.frame = CGRectMake(CGRectGetMinX(labelFrame), CGRectGetMinY(indicatorFrame), CGRectGetWidth(labelFrame), CGRectGetHeight(indicatorFrame))
            // Scroll animation if distributeEvenly is false
            if !self.distributeEvenly {
                if CGRectGetMinX(labelFrame) < CGRectGetWidth(self.frame)/2 { // The first places
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                } else { // The rest
                    // If the remaining space is smaller than a CGRectGetWidth(self.frame)
                    let lastWidth = self.scrollView.contentSize.width - CGRectGetMinX(labelFrame) - (CGRectGetWidth(self.frame) - CGRectGetWidth(labelFrame))/2
                    if lastWidth < CGRectGetWidth(self.frame)/2 - CGRectGetWidth(labelFrame)/2 {
                        let xLastOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.frame)
                        self.scrollView.contentOffset = CGPoint(x: xLastOffset, y: 0)
                    } else {
                        // If not
                        let xOffset = (CGRectGetWidth(self.frame) - CGRectGetWidth(labelFrame))/2
                        self.scrollView.contentOffset = CGPoint(x: CGRectGetMinX(labelFrame) - xOffset, y: 0)
                    }
                }
            }
        }
    }
    
    // MARK: - Public methods
    public func reloadData() {
        xOffset = 0
        scrollView.subviews.map { $0.removeFromSuperview() }
        addTabsView()
        addIndicatorView()
    }
    
    public func setCurrentTab(index: Int) {
        currentTabSelected = index
        animateIndicator(index)
    }
}
