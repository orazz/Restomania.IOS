//
//  OnePlaceOneActionImageCell.swift
//  FindMe
//
//  Created by Алексей on 01.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OnePlaceOneActionImageCell: UITableViewCell {

    private static let nibName = "OnePlaceOneActionImageCell"
    public static func create(for place: DisplayPlaceInfo, with action: Action) -> OnePlaceOneActionImageCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceOneActionImageCell

        cell.update(for: place, with: action)

        return cell
    }

    //MARK: UI elements
    @IBOutlet private weak var ImageView: ImageWrapper!

    //MARK: Data
    private var place: DisplayPlaceInfo!
    private var action: Action! {
        didSet {
            ImageView.setup(url: action.image)
        }
    }
}
extension OnePlaceOneActionImageCell: OnePlaceOneActionCell {
    public func update(for place: DisplayPlaceInfo, with action: Action) {

        self.place = place
        self.action = action
    }
}
extension OnePlaceOneActionImageCell: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        if (String.isNullOrEmpty(action.image)) {
            return 0
        }
        else {
            return 200
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
