//
//  OnePlaceViewHeader.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceViewHeader: UIView {

    private static let nibName = "OnePlaceView-Header"
    public static func build(place: Place) -> OnePlaceViewHeader {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceViewHeader

        instance.update(by: place)

        return instance
    }


    //MARk: UIElements
    @IBOutlet public weak var NameLabel: FMTitleLabel!
    @IBOutlet public weak var Slider: SliderControl!

    //MARK: Data & services
    private var _source: Place? = nil

    public func update(by place: Place){

        _source = place
        NameLabel.text = place.name

        var images = place.images.sorted(by: { $0.orderNumber > $1.orderNumber })
        if (images.isEmpty) {
            images.append(PlaceImage())
        }

        var slides = [ImageWrapper]()
        for image in images {
            let wrapper = ImageWrapper.init(frame: Slider.frame)
            wrapper.setup(url: image.link)
            wrapper.clipsToBounds = true
            wrapper.contentMode = .scaleAspectFill

            slides.append(wrapper)
        }
        Slider.setup(slides: slides) 
    }
}
