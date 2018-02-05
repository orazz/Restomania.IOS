//
//  AvatarImage.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class AvatarImage: CachedImage {

    public override func afterInit() {
        super.afterInit()

        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = ThemeSettings.Colors.main.cgColor
        self.layer.borderWidth = 2.0
    }
}
