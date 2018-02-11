//
//  OnePlaceMainDividerCell.swift
//  FindMe
//
//  Created by Алексей on 16.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public protocol OnePlaceShowDividerDelegate {

    func needShow() -> Bool
}
public class OnePlaceMainDividerCell: UITableViewCell {

    private static let nibName = "OnePlaceMainDividerCell"
    public static func instance(for delegate: OnePlaceShowDividerDelegate) -> OnePlaceMainDividerCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainDividerCell

        instance._delegate = delegate

        return instance
    }

    private var _delegate: OnePlaceShowDividerDelegate!
}
extension OnePlaceMainDividerCell: OnePlaceMainCellProtocol {

    public func update(by place: DisplayPlaceInfo) {}
}
extension OnePlaceMainDividerCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {

        if (_delegate.needShow()) {
            return 11
        }
        else {
            return 0
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
