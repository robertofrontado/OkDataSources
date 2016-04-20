//
//  CollectionViewController.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/8/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, OkViewCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: OkCollectionViewDataSource<Item, CollectionViewCell>!
    var delegate: OkCollectionViewDelegate<OkCollectionViewDataSource<Item, CollectionViewCell>, CollectionViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkCollectionViewDataSource()
        delegate = OkCollectionViewDelegate(dataSource: dataSource, presenter: self)
        delegate.setOnPullToRefresh(collectionView) { (refreshControl) -> Void in
            print("refreshed")
            refreshControl.endRefreshing()
        }
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        showMockItems()
    }
    
    private func showMockItems() {
        var items = [Item]()
        for i in 0..<10 {
            items.append(Item(value: "Item \(i)"))
        }
        dataSource.items = items
        collectionView.reloadData()
    }
    
    // MARK: - OkViewCellDelegate
    func onItemClick(item: Item, position: Int) {
        showAlertMessage("\(item.value) clicked")
    }
    
}
