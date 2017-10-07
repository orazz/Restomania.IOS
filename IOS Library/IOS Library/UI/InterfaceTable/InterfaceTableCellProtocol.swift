//
//  InterfaceTableCellProtocol.swift
//  IOSLibrary
//
//  Created by Алексей on 08.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol InterfaceTableCellProtocol
{
    var viewHeight: Int { get }
    func prepareView() -> UITableViewCell

    @objc optional func select(with: UINavigationController)
}
