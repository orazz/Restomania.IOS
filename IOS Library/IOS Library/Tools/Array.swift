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
    public func count( _ predicate: (Element) -> Bool) -> Int {

        var result = 0

        for element in self {
            if (predicate(element)) {
                result += 1
            }
        }

        return result
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
    public func all( _ predicate: (Element) -> Bool) -> Bool {

        for element in self {
            if (!predicate(element)) {
                return false
            }
        }

        return true
    }
    public func any( _ predicate: (Element) -> Bool) -> Bool {

        for element in self {
            if (predicate(element)) {
                return true
            }
        }

        return false
    }
    public func notAny( _ predicate: (Element) -> Bool) -> Bool {
        return !self.any(predicate)
    }
    public func sum(_ predicate: (Element) -> Int) -> Int {

        var result = 0

        for element in self {
            result += predicate(element)
        }

        return result
    }
    public var isFilled: Bool {
        return !self.isEmpty
    }
}
