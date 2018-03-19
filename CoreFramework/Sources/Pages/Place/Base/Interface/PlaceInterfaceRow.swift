//
//  PlaceInterfaceRow.swift
//  CoreFramework
//
//  Created by Алексей on 19.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol PlaceInterfaceRow: InterfaceTableCellProtocol {

    func viewWillAppear()
    func viewDidDisappear()
}
extension PlaceInterfaceRow {
    
    public func viewWillAppear() {}
    public func viewDidDisappear() {}
}
