//
//  OnePlaceMainLastActionCell.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

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
    private var place: DisplayPlaceInfo?
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
        self.place = place
        self.lastAction = place.lastAction
    }
}
extension OnePlaceMainLastActionCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        if (!needShow()) {
            return 0
        }
        else {
            return 100
        }
    }
    public func select(with controller: UINavigationController) {

        let vc = OnePlaceActionsController.create(for: place!)
        controller.pushViewController(vc, animated: true)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
