//
//  ZeroCdnImageWrapper.swift
//  IOSLibrary
//
//  Created by Алексей on 22.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask

public protocol ZeroCdnImageWrapperDelegate: ImageWrapperDelegate {

    var cache: CacheImagesService { get }
    var sizes: [CGFloat: String] { get }
}
open class ZeroCdnImageWrapper: BaseImageWrapper {

    private var cdnDelegate: ZeroCdnImageWrapperDelegate?

    public func setup(delegate: ZeroCdnImageWrapperDelegate) {
        self.delegate = delegate
        self.cdnDelegate = delegate
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

        guard let delegate = cdnDelegate else {
            return nil
        }

        let sizes = delegate.sizes
        var prev = sizes.keys.first!
        for key in sizes.keys {

            if (size < key) {
                return sizes[prev]
            }

            prev = key
        }

        return nil
    }
    public func download(url: String) -> Task<UIImage?> {

        return Task<UIImage?> { handler in
            guard let delegate = self.cdnDelegate else {
                handler(nil)
                return
            }

            let task = delegate.cache.download(url: url)
            task.async(.background) { result in

                if let data = result.data {
                    handler(UIImage(data: data))
                } else {
                    handler(nil)
                }
            }
        }
    }
}
