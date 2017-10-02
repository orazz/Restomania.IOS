//
//  SliderControlDelegate.swift
//  FindMe
//
//  Created by Алексей on 02.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public protocol SliderControlDelegate {

    func move(slider: SliderControl, focusOn: Int)
}
