//
//  ImageControllerSlide.swift
//  FindMe
//
//  Created by Алексей on 06.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ImageControllerSlide: UIView {

    private static let nibName = "ImageControllerSlideView"
    public static func instance(image: ImagesController.ImageContainer) -> ImageControllerSlide {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! ImageControllerSlide

        instance._sourceImage = image

        return instance
    }

    //UI elements
    @IBOutlet private weak var imageView: CachedImage!
    @IBOutlet private weak var descriptionLabel: UILabel!

    //Data & services
    private var _sourceImage: ImagesController.ImageContainer! {
        didSet {
            updateUI()
        }
    }

    public func updateUI() {

        imageView.setup(url: _sourceImage.link)
        descriptionLabel.text = _sourceImage.description
    }
    public func setupStyles() {

    }
}
