//
//  NumberFilter.swift
//  IOS Library
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

internal class NumberFilter: IFilter {

    public func search(phrase: String, field: Any) -> Bool {

        let value = field as? Int
        if (nil == value) {
            return false
        }

        return nil != "\(value!)".range(of: phrase)
    }
}
