//
//  CollectionViewController.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/8/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: OkCollectionViewDataSource<Item, CollectionViewCell>!
    var delegate: OkCollectionViewDelegate<OkCollectionViewDataSource<Item, CollectionViewCell>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkCollectionViewDataSource()
        delegate = OkCollectionViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
                self.showAlertMessage("\(item.value) clicked")
        })
        delegate.setOnPullToRefresh(collectionView) { (refreshControl) -> Void in
            print("refreshed")
            refreshControl.endRefreshing()
        }
        delegate.setOnPagination { (item) -> Void in
            self.addMockItems(self.dataSource.items.count)
        }
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        addMockItems()
    }
    
    private func addMockItems(_ count: Int = 0) {
        var items = [Item]()
        for i in count..<(count + 30) {
            items.append(Item(value: "Item \(i)"))
        }
        dataSource.items.append(contentsOf: items)
        collectionView.reloadData()
    }
    
}
