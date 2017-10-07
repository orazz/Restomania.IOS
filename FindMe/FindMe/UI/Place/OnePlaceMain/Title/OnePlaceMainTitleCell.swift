//
//  OnePlaceMainTitleCell.swift
//  FindMe
//
//  Created by Алексей on 08.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainTitleCell: UITableViewCell {

    private static let nibName = "OnePlaceMainTitleCell"
    public static var instance: OnePlaceMainTitleCell  {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainTitleCell

        instance._place = nil

        return instance
    }

    //MARK: UI Elements
    @IBOutlet public weak var NameTitle: FMTitleLabel!

    //MARK: Data & Services
    public var _place: Place? {
        didSet {

            if let place = _place {
                NameTitle?.text = place.name
            }
            else {
                NameTitle?.text = String.empty
            }
        }
    }
}
extension OnePlaceMainTitleCell: OnePlaceMainCellProtocol {
    
    public func update(by place: Place){
        _place = place
    }
}
extension OnePlaceMainTitleCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 55
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
