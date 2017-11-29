//
//  OnePlaceMainLastActionCell.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainLastActionCell: UITableViewCell {

    private static let nibName = "OnePlaceMainLastActionCell"
    public static var instance: OnePlaceMainLastActionCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainLastActionCell

        instance.lastAction = nil

        return instance
    }

    //MARK: UI Elements
    @IBOutlet public weak var TitleLabel: UILabel!
    @IBOutlet public weak var LastActionLabel: UILabel!


    //MARK: Data & services
    private var lastAction: String? {
        didSet{
            updateDescription()
        }
    }

    private func updateDescription() {

        LastActionLabel?.text = lastAction
    }
}

extension OnePlaceMainLastActionCell: OnePlaceShowDividerDelegate {

    public func needShow() -> Bool {
        return !String.isNullOrEmpty(lastAction)
    }
}
extension OnePlaceMainLastActionCell: OnePlaceMainCellProtocol {

    public func update(by place: DisplayPlaceInfo) {
        lastAction = place.lastAction
    }
}
extension OnePlaceMainLastActionCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        if (!needShow()) {
            return 0
        }
        else {
            return 95
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
