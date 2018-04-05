//
//  PlaceCartElement.swift
//  CoreFramework
//
//  Created by Алексей on 06.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit


public protocol PlaceCartElement {

    func cartWillAppear()
    func cartWillDisappear()
    func update(with: PlaceCartDelegate)
    func height() -> CGFloat
}
extension PlaceCartElement {
    public func cartWillAppear() {}
    public func cartWillDisappear() {}
    public func update(with: PlaceCartDelegate) {}
}
