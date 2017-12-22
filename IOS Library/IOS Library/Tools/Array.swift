//
//  Array.swift
//  IOS Library
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public extension Array {

    public var isFilled: Bool {
        return !self.isEmpty
    }
    public func find(_ predicate: Predicate<Element>) -> Element? {

        for element in self {
            if (predicate(element)) {
                return element
            }
        }

        return nil
    }
    public func count( _ predicate: Predicate<Element>) -> Int {

        var result = 0

        for element in self {
            if (predicate(element)) {
                result += 1
            }
        }

        return result
    }
    public func `where`(_ predicate: Predicate<Element>) -> [Element] {

        var result = [Element]()

        for element in self {
            if (predicate(element)) {
                result.append(element)
            }
        }

        return result
    }
    public func all( _ predicate: Predicate<Element>) -> Bool {

        for element in self {
            if (!predicate(element)) {
                return false
            }
        }

        return true
    }
    public func any( _ predicate: Predicate<Element>) -> Bool {

        for element in self {
            if (predicate(element)) {
                return true
            }
        }

        return false
    }
    public func notAny( _ predicate: Predicate<Element>) -> Bool {
        return !self.any(predicate)
    }
    public func sum(_ predicate: Function<Element, Int>) -> Int {

        var result = 0

        for element in self {
            result += predicate(element)
        }

        return result
    }
    public func each(_ action: Action<Element>) {
        
        for element in self {
            action(element)
        }
    }
}
