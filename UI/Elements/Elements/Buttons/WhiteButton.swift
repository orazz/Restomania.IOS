//
//  WhiteButton.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import CoreTools
import UITools

public class WhiteButton: BaseButton {

    override func stylize() {

        let colors = DependencyResolver.resolve(ThemeColors.self)

        super.stylize(textColor: colors.actionMain,
                      backgroundColor: colors.actionContent,
                      borderColor: colors.actionMain)
    }
}
