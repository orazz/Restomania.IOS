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
import AsyncTask

public class ImageWrapper: BaseImageWrapper, ImageWrapperDelegate {

    private var _cache: CacheImagesService?
    private var _sizes:[CGFloat: String]?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)

        initialize()
    }
    private func initialize(){

        delegate = self

        _cache = ServicesFactory.shared.images
        _sizes = [:]
        _sizes![CGFloat(50)] = "t"
        _sizes![CGFloat(150)] = "s"
        _sizes![CGFloat(350)] = "m"
    }

    //MARK: ImageWrapperDelegate
    public var defaultImage: UIImage {

        return ThemeSettings.Images.default
    }
    public func prepare(url: String, width: CGFloat) -> String {

        if (!url.contains("cdn.zerocdn.com")) {
            return url
        }

        let suffix = buildSuffix(size: self.bounds.width)

        if let suffix = suffix {

            let lastDotRange = url.range(of: ".", options: .backwards, range: nil, locale: nil)
            return url.replacingCharacters(in: lastDotRange!, with: "-\(suffix).")
        } else {

            return url
        }
    }
    private func buildSuffix(size: CGFloat) -> String? {

        var prev = _sizes!.keys.first!
        for key in _sizes!.keys {

            if (size < key) {
                return _sizes![prev]
            }

            prev = key
        }

        return nil
    }
    public func download(url: String) -> Task<UIImage?> {

        return Task<UIImage?>(action: { handler in

            guard let task = self._cache?.download(url: url) else {
                handler(nil)
                return
            }
            task.async(.background, completion: { result in

                if let data = result.data {
                    handler(UIImage(data: data))
                }
                else {
                    handler(nil)
                }
            })

        })
    }
}
