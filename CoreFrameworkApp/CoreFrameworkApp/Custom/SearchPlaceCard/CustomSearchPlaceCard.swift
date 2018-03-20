//
//  CustomSearchPlacecard.swift
//  Kuzina
//
//  Created by Алексей on 13.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import CoreFramework

open class CustomSearchPlaceCard: SearchPlaceCard {

    @IBOutlet weak var kunaLogo: UIImageView!
    @IBOutlet weak var verticalLines: UIImageView!

    @IBOutlet weak var bottomBorderPink: UIView!

    open override func awakeFromNib() {
        super.awakeFromNib()

//        topBorderPink.backgroundColor = ThemeSettings.Colors.pink
//        leftBorderPink.backgroundColor = ThemeSettings.Colors.pink
        bottomBorderPink.backgroundColor = ThemeSettings.Colors.pink
//        bottomBorderBackground.backgroundColor = themeColors.contentBackground

        location?.font = themeFonts.bold(size: .head)
        location?.textColor = themeColors.contentText
    }
}
