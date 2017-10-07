//
//  ImageWrapper.swift
//  IOSLibrary
//
//  Created by Алексей on 26.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask

open class BaseImageWrapper: UIImageView {

    public var delegate: ImageWrapperDelegate? {
        didSet {

            if (nil == self.image) {

                self.image = delegate?.defaultImage
            }
        }
    }

    public var useAnimation: Bool = true
    private var _url: String?

    // MARK: Constructors & initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)!

        initialize()
    }
    private func initialize() {

        self.contentMode = .scaleAspectFill
        self.backgroundColor = UIColor.white
    }

    public func setup(url: String) {

        let url = delegate?.prepare(url: url, width: frame.width)

        if (_url == url) {
            return
        }

        _url = url

        if (String.isNullOrEmpty(url)) {

            self.animatedSetupImage(nil)
            return
        }

        if let task = delegate?.download(url: url!) {
            task.async(.background, completion: { result in

                if let data = result {

                    self.animatedSetupImage(data)
                }
            })
        }
    }
    private func animatedSetupImage(_ image: UIImage? = nil) {

        let image = image ?? delegate?.defaultImage

        DispatchQueue.main.async {

            if (!self.useAnimation) {
                self.image = image
                return
            }

            let duration = 0.2
            UIView.animate(withDuration: duration, animations: { self.alpha = 0 }, completion: ({ _ in

                self.image = image
                UIView.animate(withDuration: duration, animations: { self.alpha = 1 })
            }))
        }
    }
}
