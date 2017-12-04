//
//  OnePlaceOneActionNameCell.swift
//  FindMe
//
//  Created by Алексей on 01.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceOneActionNameCell: UITableViewCell {

    private static let nibName = "OnePlaceOneActionNameCell"
    public static func create(for place: DisplayPlaceInfo, with action: Action) -> OnePlaceOneActionNameCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceOneActionNameCell

        cell.update(for: place, with: action)

        return cell
    }

    //MARK: UI elements
    @IBOutlet private weak var NameLabel: UILabel!

    //MARK: Data
    private var place: DisplayPlaceInfo!
    private var action: Action! {
        didSet {
            NameLabel.text = action.name
        }
    }
}
extension OnePlaceOneActionNameCell: OnePlaceOneActionCell {
    public func update(for place: DisplayPlaceInfo, with action: Action) {

        self.place = place
        self.action = action
    }
}
extension OnePlaceOneActionNameCell: InterfaceTableCellProtocol {
    public var viewHeight: Int {

        let value = action.name
        if (String.isNullOrEmpty(value)) {
            return 0
        }
        else {

            let width = NameLabel.frame.width
            let font = NameLabel.font!
            let height = value.height(containerWidth: width, font: font)

            return 15 + Int(height) + 5
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}

