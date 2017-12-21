//
//  PartsLoader.swift
//  IOSLibrary
//
//  Created by Алексей on 20.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class PartsLoader {

    private var loaders: [PartsLoadContainer]

    public init(_ loaders: [PartsLoadContainer]) {

        self.loaders = loaders
    }


    public var isLoad: Bool {
        return loaders.all{ $0.isLoad }
    }
    public var hasData: Bool {
        return loaders.all{ $0.hasData }
    }
    public var isFail: Bool {
        return loaders.any{ $0.isFail }
    }
}
