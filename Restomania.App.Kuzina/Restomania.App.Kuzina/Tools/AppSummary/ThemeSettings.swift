//
//  Theme.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class ThemeSettings {

    public let blackColor = UIColor(colorLiteralRed: 34/255, green: 31/255, blue: 30/255, alpha: 1)
    public let whiteColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
    public let greyColor = UIColor(colorLiteralRed: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    public let borderColor = UIColor(colorLiteralRed: 165/255, green: 165/255, blue: 165/255, alpha: 1)
    public let backgroundColor = UIColor(colorLiteralRed: 234/255, green: 234/255, blue: 234/255, alpha: 1)

    public var defaultImage = UIImage(contentsOfFile: "\(Bundle.main.bundlePath)/default-image.jpg")!

    public let fontAwesomeFont = "FontAwesome"
    public let susanBookFont = "Susan Book"
    public let susanBoldFont = "Susan Bold"

    public let titleFontSize = CGFloat(20)
    public let headlineFontsize = CGFloat(17)
    public let subheadFontSize = CGFloat(15)
    public let captionFontSize = CGFloat(12)
}
