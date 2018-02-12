////
////  WrappedImage.swift
////  FindMe
////
////  Created by Алексей on 25.09.17.
////  Copyright © 2017 Medved-Studio. All rights reserved.
////

import Foundation
import MdsKit
import UIKit

public class CachedImage: ZeroCdnImageWrapper {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        afterInit()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)

        afterInit()
    }
    public override func awakeFromNib() {
        super.awakeFromNib()

        afterInit()
    }
    public func afterInit() {
        super.setup(delegate: self)
    }
}
extension CachedImage: ZeroCdnImageWrapperDelegate {

    public var defaultImage: UIImage {
        return ThemeSettings.Images.default
    }
    public var cache: CacheImagesService {
        return CacheServices.images
    }
    public var sizes: [CGFloat: String] {
        return CachedImage.sizes
    }
    private static let sizes = [
        CGFloat(50): "t",
        CGFloat(150): "s",
        CGFloat(350): "m"
    ]
}
