//
//  IIdentified.swift
//  MdsKit
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public protocol IIdentified {

    var ID: Long { get }
}
extension Array where Element: IIdentified {
    public func find(id: Long) -> Element? {
        return self.find({ $0.ID == id })
    }
}
