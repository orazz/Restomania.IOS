//
//  BlackBottomButton.swift
//  Kuzina
//
//  Created by Алексей on 12.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import CoreTools
import UITools

public class BlackBottomButton: BlackButton {

    override func stylize() {

        let colors = DependencyResolver.resolve(ThemeColors.self)

        super.stylize(textColor: colors.actionContent,
                      backgroundColor: colors.actionMain,
                      borderColor: colors.actionMain)

        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
    }
}
