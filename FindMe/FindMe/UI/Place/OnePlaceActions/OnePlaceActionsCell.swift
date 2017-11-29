//
//  OnePlaceActionsCell.swift
//  FindMe
//
//  Created by Алексей on 30.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceActionsCell: UITableViewCell {

    private static let nibName = "OnePlaceActionsCellView"
    public static func create(for action: Action) -> OnePlaceActionsCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceActionsCell

        return cell
    }

    public var height: CGFloat {
        return self.frame.height
    }
}
