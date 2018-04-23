//
//  DishModalElementProtocol.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol DishModalElementProtocol: InterfaceTableCellProtocol {

    func link(with: DishModalDelegate)
    func update(by: BaseDish, from: MenuSummary)
}
extension DishModalElementProtocol {

    public func link(with: DishModalDelegate) {}
    public func update(by: BaseDish, from: MenuSummary) {}
}
