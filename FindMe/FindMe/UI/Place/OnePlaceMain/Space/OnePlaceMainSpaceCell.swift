//
//  OnePlaceMainSpaceCell.swift
//  FindMe
//
//  Created by Алексей on 16.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainSpaceCell: UITableViewCell {

    private static let nibName = "OnePlaceMainSpaceCell"
    public static var instance: OnePlaceMainSpaceCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainSpaceCell
        
        return instance
    }
}
extension OnePlaceMainSpaceCell: OnePlaceMainCellProtocol {

    public func update(by place: Place) {}
}
extension OnePlaceMainSpaceCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 50
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
