//
//  UIImage.swift
//  IOSLibrary
//
//  Created by Алексей on 15.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    public func normalizeOrientation() -> UIImage? {

        switch (self.imageOrientation) {
            case .up:
                return self
            case .right:
                return UIImage.rotateImage(image: self, angle: 90)
            case .down:
                return UIImage.rotateImage(image: self, angle: 180)
            case .left:
                return UIImage.rotateImage(image: self, angle: -90)
            default:
                return nil
        }
    }
    private static func rotateImage(image: UIImage, angle: CGFloat) -> UIImage? {

        let ciImage = CIImage(image: image)
        let flipVertical = CGFloat(0)
        let flipHorizontal = CGFloat(0)

        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setDefaults()

        let newAngle = angle * CGFloat.pi/180 * CGFloat(-1)

        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipVertical) * Double.pi), 0, 1, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipHorizontal) * Double.pi), 1, 0, 0)

        let affineTransform = CATransform3DGetAffineTransform(transform)

        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")

        let contex = CIContext(options: [kCIContextUseSoftwareRenderer:true])

        let outputImage = filter?.outputImage
        let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)

        let result = UIImage(cgImage: cgImage!)
        return result
    }
}
