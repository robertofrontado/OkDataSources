//
//  SinglePageViewController.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 5/12/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

class SinglePageViewController: UIViewController {

    @IBOutlet weak var pageIndexLabel: UILabel!
    
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageIndexLabel.text = "Page number: \(pageIndex)"
    }

}
