//
//  WrappedImage.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 23.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import AsyncTask

public class WrappedImage: UIImageView {

    private let _tag = "WrappedImage"
    private let _images = ServicesManager.current.images
    private let _theme = AppSummary.current.theme
    private var _url: String?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.image = _theme.defaultImage
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)!

        self.image = _theme.defaultImage
    }

    public func setup(url: String) {

        let url = prepare(url: url)
        if (_url == url) {
            return
        }

        let task = _images.download(url: url)
        task.async(.background, completion: { result in

            var image: UIImage?

            if (result.success) {
                image = UIImage(data: result.data!)!
            } else {
                image = nil
            }

            self.animatedSetupImage(image)
        })
    }
    private func prepare(url: String) -> String {
        return url
    }
    private func animatedSetupImage(_ image: UIImage? = nil) {

        let image = image ?? self._theme.defaultImage

        DispatchQueue.main.async {

           UIView.animate(withDuration: 0.1, animations: { self.alpha = 0 }, completion: ({ _ in

                self.image = image
                UIView.animate(withDuration: 0.2, animations: { self.alpha = 1 })
           }))
        }
    }
}
