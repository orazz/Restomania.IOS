//
//  WhiteButton.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

public class WhiteButton: BaseButton {

    override func stylize() {
        super.stylize(textColor: theme.blackColor, backgroundColor: theme.whiteColor)
    }
}
