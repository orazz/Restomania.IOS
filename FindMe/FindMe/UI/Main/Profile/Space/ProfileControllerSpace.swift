//
//  ProfileControllerSpace.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ProfileControllerSpace: UITableViewCell {

    public static func create(large:Bool = false) -> ProfileControllerSpace {

        let cell: ProfileControllerSpace = UINib.instantiate(from: "\(String.tag(ProfileControllerSpace.self))View", bundle: Bundle.main)
        cell.isLarge = large

        return cell
    }

    //Data
    private var isLarge: Bool = false
}
extension ProfileControllerSpace: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return isLarge ? 50 : 30
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
