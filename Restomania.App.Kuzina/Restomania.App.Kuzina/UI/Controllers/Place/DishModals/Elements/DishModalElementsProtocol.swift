//
//  DishModalElementsProtocol.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public protocol DishModalElementsProtocol: InterfaceTableCellProtocol {

    func link(with: DishModalDelegateProtocol)
    func update(by: BaseDish, from: MenuSummary)
}
extension DishModalElementsProtocol {

    public func link(with: DishModalDelegateProtocol) {}
    public func update(by: BaseDish, from: MenuSummary) {}
}
