//
//  TableViewController.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/8/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: OkTableViewDataSource<Item, TableViewCell>!
    var delegate: OkTableViewDelegate<OkTableViewDataSource<Item, TableViewCell>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkTableViewDataSource()
        delegate = OkTableViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
            self.showAlertMessage("\(item.value) clicked")
        })
        delegate.setOnPullToRefresh(tableView) { (refreshControl) -> Void in
            print("refreshed")
            refreshControl.endRefreshing()
        }
        delegate.setOnPagination { (item) -> Void in
            self.addMockItems(self.dataSource.items.count)
          
        }
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        addMockItems()
    }
    
    private func addMockItems(_ count: Int = 0) {
        var items = [Item]()
        for i in count..<(count + 10) {
            items.append(Item(value: "Item \(i)"))
        }
        dataSource.items.append(contentsOf: items)
        tableView.reloadData()
    }

}
