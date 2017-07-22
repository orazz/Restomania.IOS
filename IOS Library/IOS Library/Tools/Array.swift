//
//  Array.swift
//  IOS Library
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public extension Array {

    public func find(_ predicate: (Element) -> Bool) -> Element? {

        for element in self {
            if (predicate(element)) {
                return element
            }
        }

        return nil
    }
    public func `where`(_ predicate: (Element) -> Bool) -> [Element] {

        var result = [Element]()

        for element in self {
            if (predicate(element)) {
                result.append(element)
            }
        }

        return result
    }
}
