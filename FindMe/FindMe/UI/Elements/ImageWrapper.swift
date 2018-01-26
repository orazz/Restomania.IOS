////
////  WrappedImage.swift
////  FindMe
////
////  Created by Алексей on 25.09.17.
////  Copyright © 2017 Medved-Studio. All rights reserved.
////

import Foundation
import IOSLibrary
import UIKit

public class ImageWrapper: ZeroCdnImageWrapper {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)

        initialize()
    }
    public override func awakeFromNib() {
        super.awakeFromNib()

        initialize()
    }
    private func initialize() {
        super.setup(delegate: self)
    }
}
extension ImageWrapper: ZeroCdnImageWrapperDelegate {

    public var defaultImage: UIImage {
        return ThemeSettings.Images.default
    }
    public var cache: CacheImagesService {
        return CacheServices.images
    }
    public var sizes: [CGFloat: String] {
        return ImageWrapper.sizes
    }
    private static let sizes = [
        CGFloat(50): "t",
        CGFloat(150): "s",
        CGFloat(350): "m"
    ]
}
