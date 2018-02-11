//
//  ISortable.swift
//  MdsKit
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public protocol ISortable {

    var orderNumber: Int { get }
}
extension Array where Element: ISortable {
    public var ordered: Array<Element> {
        return self.sorted(by: { $0.orderNumber < $1.orderNumber })
    }
}
