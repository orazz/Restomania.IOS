//
//  BottomAction.swift
//  Kuzina
//
//  Created by Алексей on 12.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import CoreTools
import UITools

open class BottomAction: DefaultButton {

    override func stylize() {

        super.stylize()

        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
    }
}
