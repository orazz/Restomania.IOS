//
//  ImageWrapper.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 23.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import UIKit
import CoreTools
import UITools

public class CachedIMage: ZeroCdnImageWrapper {

    public override func awakeFromNib() {
        super.awakeFromNib()

        super.setup(delegate: self)
    }
}

extension CachedIMage: ZeroCdnImageWrapperDelegate {

    public var defaultImage: UIImage {
        return DependencyResolver.resolve(ThemeImages.self).toolsDefaultImage
    }
    public var cache: CacheImagesService {
        return DependencyResolver.resolve(CacheImagesService.self)
    }
    public var sizes: [CGFloat: String] {
        return CachedIMage.sizes
    }
    private static let sizes = [
        CGFloat(40): "xss",
        CGFloat(150): "xs",
        CGFloat(250): "s",
        CGFloat(400): "m",
        CGFloat(600): "l",
        CGFloat(800): "xl",
        CGFloat(1000): "xxl"
    ]
}
