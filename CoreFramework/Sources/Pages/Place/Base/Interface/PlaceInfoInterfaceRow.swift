//
//  PlaceInfoInterfaceRow.swift
//  CoreFramework
//
//  Created by Алексей on 19.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol PlaceInfoInterfaceRow {

    func viewDidAppear()
    func viewDidDisappear()
    func update(delegate: PlaceDelegate)
}
extension PlaceInfoInterfaceRow {

    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func update(delegate: PlaceDelegate) {}
}

