//
//  OkViewCell.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

public protocol OkViewCell {
    static var identifier: String { get }
    
    associatedtype ItemType
    
    func configureItem(_ item: ItemType)
}

public extension OkViewCell {
    public static var identifier: String { return String(describing: Self.self) }
}
