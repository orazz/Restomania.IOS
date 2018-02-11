//
//  Object.swift
//  MdsKit
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public extension NSObject {

    public var tag: String {

        return String(describing: type(of: self))
    }
}
