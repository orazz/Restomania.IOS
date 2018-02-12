//
//  BlackButton.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

public class BlackButton: BaseButton {

    override func stylize() {
        super.stylize(textColor: ThemeSettings.Colors.additional,
                      backgroundColor: ThemeSettings.Colors.main,
                      borderColor: ThemeSettings.Colors.main)
    }
}
