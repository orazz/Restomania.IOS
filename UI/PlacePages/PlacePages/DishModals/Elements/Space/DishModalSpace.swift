//
//  DishModalSpace.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSpace: UITableViewCell {

    public static func create() -> DishModalSpace {

        let cell: DishModalSpace = UINib.instantiate(from: "\(String.tag(DishModalSpace.self))View", bundle: Bundle.main)

        return cell
    }
}
extension DishModalSpace: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 30
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
