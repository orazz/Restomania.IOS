//
//  BlackBottomButton.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 12.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class BlackBottomButton: BlackButton {

    override func stylize() {
        super.stylize(textColor: theme.whiteColor, backgroundColor: theme.blackColor, borderColor: theme.borderColor)

        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
    }
}
