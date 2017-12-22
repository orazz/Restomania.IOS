//
//  Extends.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 22.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

extension PartsLoadTypedContainer
    where TData: ICached {

    public func updateAndCheckFresh(_ update: TData, cache: CacheAdapterExtender<TData>) {

        self.update(update)

        if (cache.isFresh(update.ID)) {
            self.completeLoad()
        }
    }
}
