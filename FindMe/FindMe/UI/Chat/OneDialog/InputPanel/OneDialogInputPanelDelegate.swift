//
//  OneDialogInputPanelDelegate.swift
//  FindMe
//
//  Created by Алексей on 08.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public protocol OneDialogInputPanelDelegate {

    func add(_ text: String)
    func deleteLast()
    func clear()
}
