//
//  OkViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 4/20/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkViewDelegate<T: OkViewDataSource>: NSObject {
    
    public var dataSource: T
    
    public let onItemClicked: (item: T.ItemType, position: Int) -> Void
    public var onRefreshed: ((refreshControl: UIRefreshControl) -> Void)?
    public var onPagination: ((item: T.ItemType) -> Void)?
    public var triggerTreshold: Int = 1
    public var reverseTriggerTreshold: Int = 0
    
    public init(dataSource: T, onItemClicked: (item: T.ItemType, position: Int) -> Void) {
        self.dataSource = dataSource
        self.onItemClicked = onItemClicked
    }
    
    // MARK: Private methods
    internal func refreshControlValueChanged(refreshControl: UIRefreshControl) {
        onRefreshed?(refreshControl: refreshControl)
    }
    
    // MARK: - Public methods
    // MARK: Pagination
    public func setOnPagination(onPagination: (item: T.ItemType) -> Void) {
        setOnPagination(nil, onPagination: onPagination)
    }
    
    public func setOnPagination(triggerTreshold: Int?, onPagination: (item: T.ItemType) -> Void) {
        if let triggerTreshold = triggerTreshold {
            self.triggerTreshold = triggerTreshold
        }
        self.onPagination = onPagination
    }
    
    // MARK: Pull to refresh
    internal func configureRefreshControl(inout refreshControl: UIRefreshControl?, onRefreshed: (refreshControl: UIRefreshControl) -> Void) {
        self.onRefreshed = onRefreshed
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.grayColor()
        }
        refreshControl!.addTarget(self, action: "refreshControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
}