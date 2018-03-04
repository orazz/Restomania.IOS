//
//  UIImage.swift
//  UITools
//
//  Created by Алексей on 22.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIImage
{
    open func tint(color: UIColor) -> UIImage
    {
        let ciImage = CIImage(image: self)
        let filter = CIFilter(name: "CIMultiplyCompositing")

        let colorFilter = CIFilter(name: "CIConstantColorGenerator")
        let ciColor = CIColor(color: color)
        colorFilter?.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter?.outputImage

        filter?.setValue(colorImage, forKey: kCIInputImageKey)
        filter?.setValue(ciImage, forKey: kCIInputBackgroundImageKey)

        return UIImage(ciImage: (filter?.outputImage)!, scale: 1.0, orientation: UIImageOrientation.down)
    }
}
