//
//  PlaceMenuElementProtocol.swift
//  CoreFramework
//
//  Created by Алексей on 18.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol PlaceMenuElementProtocol {

    var delegate: PlaceMenuDelegate? { get set}
    func viewWillAppear()
    func viewDidDisappear()
    func update(delegate: PlaceMenuDelegate)
}
extension PlaceMenuElementProtocol {

    public func viewWillAppear() {}
    public func viewDidDisappear() {}
    public func update(delegate: PlaceMenuDelegate) {}
}
