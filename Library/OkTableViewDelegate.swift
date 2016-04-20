//
//  OkTableViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkTableViewDelegate<T: OkViewDataSource, U: OkViewCellDelegate where T.ItemType == U.ItemType>: NSObject, UITableViewDelegate {
    
    public let dataSource: T
    public let presenter: U
    public var onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void = { _ in return }
    private var tableView: UITableView!
    
    public init(dataSource: T, presenter: U) {
        self.dataSource = dataSource
        self.presenter = presenter
    }
    
    // MARK: - Private methods
    internal func refreshControlValueChanged(refreshControl: UIRefreshControl) {
        onRefreshedBlock(refreshControl: refreshControl)
    }
    
    // MARK: - Public methods
    public func setOnPullToRefresh(tableView: UITableView, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void) {
        setOnPullToRefresh(nil, tableView: tableView, onRefreshedBlock: onRefreshedBlock)
    }
    
    public func setOnPullToRefresh(var refreshControl: UIRefreshControl?, tableView: UITableView, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void) {
        
        self.onRefreshedBlock = onRefreshedBlock
        self.tableView = tableView
        
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.grayColor()
        }
        
        refreshControl!.addTarget(self, action: "refreshControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.itemAtIndexPath(indexPath)
        presenter.onItemClick(item, position: indexPath.row)
    }
}
