//
//  RxCollectionViewController.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

class RxCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: OkCollectionViewDataSource<Item, CollectionViewCell>!
    var delegate: OkRxCollectionViewDelegate<OkCollectionViewDataSource<Item, CollectionViewCell>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkCollectionViewDataSource()
        delegate = OkRxCollectionViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
                self.showAlertMessage("\(item.value) clicked")
        })
        delegate.setOnPullToRefresh(collectionView) {
            return Observable.just(self.getMockItems())
        }
        delegate.setOnPagination { (item) -> Observable<[Item]> in
            return Observable.just(self.getMockItems(self.dataSource.items.count))
        }
       
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        dataSource.items.appendContentsOf(getMockItems())
        collectionView.reloadData()
    }
    
    private func getMockItems(count: Int = 0) -> [Item] {
        var items = [Item]()
        for i in count..<(count + 30) {
            items.append(Item(value: "Item \(i)"))
        }
        return items
    }

}
