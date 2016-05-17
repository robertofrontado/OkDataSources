//
//  OkCollectionViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/21/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkCollectionViewDelegate<T: OkViewDataSource>: OkViewDelegate<T>, UICollectionViewDelegate {
    
    public override init(dataSource: T, onItemClicked: (item: T.ItemType, position: Int) -> Void) {
        super.init(dataSource: dataSource, onItemClicked: onItemClicked)
    }
    
    // MARK: - Public methods
    // MARK: Pull to refresh
    public func setOnPullToRefresh(collectionView: UICollectionView, onRefreshed: (refreshControl: UIRefreshControl) -> Void) {
        setOnPullToRefresh(collectionView, onRefreshed: onRefreshed, refreshControl: nil)
    }
    
    public func setOnPullToRefresh(collectionView: UICollectionView, onRefreshed: (refreshControl: UIRefreshControl) -> Void, var refreshControl: UIRefreshControl?) {
        configureRefreshControl(&refreshControl, onRefreshed: onRefreshed)
        collectionView.addSubview(refreshControl!)
        collectionView.alwaysBounceVertical = true
    }
    
    // MARK: UICollectionViewDelegate
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // Ask for nextPage every time the user is getting close to the trigger treshold
        if dataSource.reverseItemsOrder {
            if reverseTriggerTreshold == indexPath.row
                && collectionView.visibleCells().count > reverseTriggerTreshold {
                    onPagination?(item: dataSource.items[indexPath.row])            }
        } else {
            if (dataSource.items.count - triggerTreshold) == indexPath.row
                && indexPath.row > triggerTreshold {
                    onPagination?(item: dataSource.items[indexPath.row])
            }
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var item = dataSource.itemAtIndexPath(indexPath)
        
        if dataSource.reverseItemsOrder {
            let inverseIndex = dataSource.items.count - indexPath.row - 1
            item = dataSource.itemAtIndexPath(NSIndexPath(forItem: inverseIndex, inSection: 0))
            onItemClicked(item: item, position: inverseIndex)
        } else {
            onItemClicked(item: item, position: indexPath.row)
        }
    }
}