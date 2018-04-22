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
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)

        // multiply blend mode
        context.setBlendMode(.multiply)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)

        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()

        return newImage.resizableImage(withCapInsets: self.capInsets, resizingMode: self.resizingMode)
    }
}
