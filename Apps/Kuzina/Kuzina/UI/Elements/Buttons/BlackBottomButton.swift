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
        super.stylize(textColor: ThemeSettings.Colors.additional,
                      backgroundColor: ThemeSettings.Colors.main,
                      borderColor: ThemeSettings.Colors.border)

        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
    }
}
