//
//  OkCollectionViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/21/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkCollectionViewDelegate<T: OkViewDataSource, U: OkViewCellDelegate where T.ItemType == U.ItemType>: NSObject, UICollectionViewDelegate {
    public let dataSource: T
    public let presenter: U
    public var onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void = { _ in return }
    private var collectionView: UICollectionView!
    
    public init(dataSource: T, presenter: U) {
        self.dataSource = dataSource
        self.presenter = presenter
    }
    
    // MARK: - Private methods
    internal func refreshControlValueChanged(refreshControl: UIRefreshControl) {
        onRefreshedBlock(refreshControl: refreshControl)
    }
    
    // MARK: - Public methods
    public func setOnPullToRefresh(collectionView: UICollectionView, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void) {
        setOnPullToRefresh(nil, collectionView: collectionView, onRefreshedBlock: onRefreshedBlock)
    }
    
    public func setOnPullToRefresh(var refreshControl: UIRefreshControl?, collectionView: UICollectionView, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void) {
        
        self.onRefreshedBlock = onRefreshedBlock
        self.collectionView = collectionView
        
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.grayColor()
        }
        
        refreshControl!.addTarget(self, action: "refreshControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl!)
        collectionView.alwaysBounceVertical = true
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.itemAtIndexPath(indexPath)
        presenter.onItemClick(item, position: indexPath.row)
    }
}