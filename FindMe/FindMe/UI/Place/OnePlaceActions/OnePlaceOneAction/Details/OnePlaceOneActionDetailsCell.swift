//
//  OnePlaceOneActionDetailsCell.swift
//  FindMe
//
//  Created by Алексей on 01.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceOneActionDetailsCell: UITableViewCell {

    private static let nibName = "OnePlaceOneActionDetailsCell"
    public static func create(for place: DisplayPlaceInfo, with action: Action) -> OnePlaceOneActionDetailsCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceOneActionDetailsCell

        cell.update(for: place, with: action)

        return cell
    }

    //MARK: UI elements
    @IBOutlet private weak var DetailsLabel: UILabel!

    //MARK: Data
    private var place: DisplayPlaceInfo!
    private var action: Action! {
        didSet {
            DetailsLabel.text = action.details
        }
    }
}
extension OnePlaceOneActionDetailsCell: OnePlaceOneActionCell {
    public func update(for place: DisplayPlaceInfo, with action: Action) {

        self.place = place
        self.action = action
    }
}
extension OnePlaceOneActionDetailsCell: InterfaceTableCellProtocol {
    public var viewHeight: Int {

        let value = action.details
        if (String.isNullOrEmpty(value)) {
            return 0
        }
        else {

            let width = DetailsLabel.frame.width
            let font = DetailsLabel.font!
            let height = value.height(containerWidth: width, font: font)

            return 10 + Int(height) + 10
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
