//
//  StringFilter.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

internal class StringFilter: IFilter {

    public func search(phrase: String, field: Any) -> Bool {

        let value = field as? String
        if (nil == value) {
            return false
        }

        if (String.IsNullOrEmpty(value)) {
            return false
        }

        let formattedValue = format(value!).joined(separator: " ")
        let formattedPhrase = format(phrase)

        if (nil != formattedValue.range(of: formattedPhrase.joined(separator: " "))) {
            return true
        }

        var result = true
        for part in formattedPhrase {
            if (nil == formattedValue.range(of: part)) {
                result = false
                break
            }
        }

        return result
    }
    private func format(_ value: String) -> [String] {

        var result = [String]()
        let range = value.lowercased().components(separatedBy: CharacterSet(charactersIn: "[] ,:.?-#;!()&\\/_+"))

        for part in range {
            if (!String.IsNullOrEmpty(part)) {
                result.append(part)
            }
        }

        return result
    }
}
