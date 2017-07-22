//
//  Theme.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class ThemeSettings {

    public var mainColor: UIColor
    public var secondColor: UIColor

    public var defaultImage: UIImage

    public init() {
        mainColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        secondColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)

        defaultImage = UIImage(contentsOfFile: "\(Bundle.main.bundlePath)/default-image.jpg")!
    }
}
