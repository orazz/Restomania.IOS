//
//  GrayButton.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import CoreTools
import UITools

open class GreyButton: BaseButton {

    override func stylize() {

        let colors = DependencyResolver.resolve(ThemeColors.self)

        super.stylize(textColor: colors.actionMain,
                      backgroundColor: colors.contentDivider,
                      borderColor: nil)
    }
}
