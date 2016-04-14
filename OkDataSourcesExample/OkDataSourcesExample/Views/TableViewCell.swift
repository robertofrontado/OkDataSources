//
//  TableViewCell.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/8/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, OkViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    func configureItem(item: Item) {
        valueLabel.text = item.value
    }

}
