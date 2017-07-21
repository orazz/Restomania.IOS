//
//  FiltersFactory.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class FiltersFactory {
    public class func create(_ type: ValueType) -> IFilter {

        switch type {
            case .String:
                return StringFilter()

            case .Number:
                return DefaultFilter()

            case .Date, .Time, .DateTime:
                return DefaultFilter()

            default:
                return DefaultFilter()
        }
    }
}
private class DefaultFilter: IFilter {

   public func search(phrase: String, field: Any) -> Bool {
        return false
    }
}
