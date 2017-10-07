//
//  OnePlaceMainSliderCell.swift
//  FindMe
//
//  Created by Алексей on 08.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainSliderCell: UITableViewCell {

    private static let nibName = "OnePlaceMainSliderCell"
    public static var instance: OnePlaceMainSliderCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainSliderCell

        instance._images = []

        return instance
    }



    //MARK: UI elements
    @IBOutlet public weak var SliderView: SliderControl!

    //MARK: Data and service
    private var _images: [PlaceImage]? {
        didSet {
            updateSlides()
        }
    }

    private func updateSlides() {


        var images = _images?.sorted(by: { $0.orderNumber < $1.orderNumber }) ?? []
        if (images.isEmpty) {
            images.append(PlaceImage())
        }

        var slides = [ImageWrapper]()
        for image in images {
            let wrapper = ImageWrapper(frame: SliderView.frame)
            wrapper.setup(url: image.link)
            wrapper.clipsToBounds = true
            wrapper.contentMode = .scaleAspectFill

            slides.append(wrapper)
        }
        SliderView.setup(slides: slides)
    }
}
extension OnePlaceMainSliderCell: OnePlaceMainCellProtocol {

    public func update(by place: Place) {
        _images = place.images
    }
}
extension OnePlaceMainSliderCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 210
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
