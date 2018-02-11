//
//  OnePlaceMainAddressCell.swift
//  FindMe
//
//  Created by Алексей on 08.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OnePlaceMainAddressCell: UITableViewCell {

    private static let nibName = "OnePlaceMainAddressCell"
    public static var instance: OnePlaceMainAddressCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainAddressCell

        instance._place = nil
        instance._location = nil

        return instance
    }


    
    //MARK: UI elements
    @IBOutlet public weak var AddressLabel: FMSubheadLabel!

    //MARK: Data & Services
    private var _place: DisplayPlaceInfo?
    private var _location: Location? {
        didSet {
            AddressLabel?.text = _location?.address ?? String.empty
        }
    }

}
extension OnePlaceMainAddressCell: OnePlaceMainCellProtocol {
    public func update(by place: DisplayPlaceInfo) {

        _place = place
        _location = place.location
    }
}
extension OnePlaceMainAddressCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 50
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
    public func select(with controller: UINavigationController) {

        let vc = OnePlaceLocationController.instance(place: _place!)

        controller.pushViewController(vc, animated: true)
    }
}
