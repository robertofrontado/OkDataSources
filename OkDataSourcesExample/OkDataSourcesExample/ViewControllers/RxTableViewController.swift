
//
//  RxTableViewController.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

class RxTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: OkTableViewDataSource<Item, TableViewCell>!
    var delegate: OkRxTableViewDelegate<OkTableViewDataSource<Item, TableViewCell>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkTableViewDataSource()
        // If you want to invert the order just set 'reverseItemsOrder' to true
        dataSource.reverseItemsOrder = true
        delegate = OkRxTableViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
                self.showAlertMessage("\(item.value) clicked")
        })
        delegate.setOnPagination { (item) -> Observable<[Item]> in
            return Observable.just(self.getMockItems(self.dataSource.items.count))
                .delaySubscription(3, scheduler: MainScheduler.instance)
            
        }
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        dataSource.items.append(contentsOf: getMockItems())
        tableView.reloadData()
    }
    
    private func getMockItems(_ count: Int = 0) -> [Item] {
        var items = [Item]()
        for i in count..<(count + 30) {
            items.append(Item(value: "Item \(i)"))
        }
        return items
    }
    
}
