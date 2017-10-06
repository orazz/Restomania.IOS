//
//  OnePlaceViewAddress.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceViewAddress: UIView {

    private static let nibName = "OnePlaceView-Address"
    public static func build(place: Place) -> OnePlaceViewAddress {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceViewAddress

        instance.update(by: place.location)

        return instance
    }


    //MARk: UIElements
    @IBOutlet public weak var AddressLabel: FMHeadlineLabel!

    //MARK: Data & services
    private var _source: Location? = nil


    //MARK: Initializations
    public override init(frame: CGRect){
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
//    public required init?(coder aDecoder: NSCoder) {
//        super.init?(coder: aDecoder)
//
//        initialize()
//    }
    private func initialize() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAption))
        self.addGestureRecognizer(tap)
    }

    public func update(by location: Location){

        _source = location
        AddressLabel.text = location.address
    }
    @objc private func tapAption() {
        
    }
}
