//
//  Extends.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 22.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import UIKit

extension PartsLoadTypedContainer
    where TData: ICached {

    public func updateAndCheckFresh(_ update: TData, cache: CacheAdapterExtender<TData>) {

        self.update(update)

        if (cache.isFresh(update.ID)) {
            self.completeLoad()
        }
    }
}
extension UILabel {

    public func setup(size: Double, units: UnitsOfSize) {

        if (0.0 == size) {
            self.text = String.empty
        } else {

            let integer = Int(floor(size))
            let float = size - Double(integer)

            if (float < 0.0001) {
                self.text = "\(integer) \(units.shortName)"
            } else {
                self.text = "\(size) \(units.shortName)"
            }
        }
    }
}
