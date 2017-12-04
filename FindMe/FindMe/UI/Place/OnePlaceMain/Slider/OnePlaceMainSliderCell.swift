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
        instance.sliderView.delegate = instance
        instance._imagesModal = ImagesController.instance(images: [])

        return instance
    }



    //MARK: UI elements
    @IBOutlet public weak var sliderView: SliderControl!
    @IBOutlet public weak var sliderIndicator: SliderIndicator!
    private var _imagesModal: ImagesController!

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
            let wrapper = ImageWrapper(frame: sliderView.frame)
            wrapper.setup(url: image.link)
            wrapper.clipsToBounds = true
            wrapper.contentMode = .scaleAspectFill

            slides.append(wrapper)
        }
        sliderView.setup(slides: slides)
        sliderIndicator.setup(size: slides.count)

        _imagesModal?.delegate = self
        _imagesModal?.setup(images: images.map({ ImagesController.ImageContainer(link: $0.link, description: $0.comment) }))
    }
}
extension OnePlaceMainSliderCell: SliderControlDelegate {

    public func move(slider: SliderControl, focusOn: Int) {
        sliderIndicator.focusTo(index: focusOn)
    }
}



extension OnePlaceMainSliderCell: OnePlaceMainCellProtocol {

    public func update(by place: DisplayPlaceInfo) {
        _images = place.images
    }
}
extension OnePlaceMainSliderCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 230
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
    public func select(with vc: UINavigationController) {

        _imagesModal.focusOn(slide: sliderView.current)
        vc.present(_imagesModal, animated: false, completion: {})
    }
}
extension OnePlaceMainSliderCell: ImagesControllerDelegate {
    public func close(vc: ImagesController) {

        self.sliderView.focusOn(slide: vc.currentSlide)
    }
}
