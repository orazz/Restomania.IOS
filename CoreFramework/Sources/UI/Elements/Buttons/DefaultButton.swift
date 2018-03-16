//
//  DefaultButton.swift
//  CoreFramework
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//


open class DefaultButton: BaseButton {

    override func stylize() {

        let colors = DependencyResolver.resolve(ThemeColors.self)

        super.stylize(textColor: colors.actionContent,
                      backgroundColor: colors.actionMain,
                      borderColor: colors.actionMain)
    }
}
