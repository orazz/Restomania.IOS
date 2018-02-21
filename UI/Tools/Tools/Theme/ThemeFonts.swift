//
//  ThemeFonts.swift
//  UITools
//
//  Created by Алексей on 22.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public enum ThemeFontsSize: Int {
    case title = 20
    case head = 17
    case subhead = 15
    case caption = 12
    case subcaption = 10
}
public protocol ThemeFonts {

    func `default`(size: ThemeFontsSize) -> UIFont
    func `default`(size: Int) -> UIFont

    func bold(size: ThemeFontsSize) -> UIFont
    func bold(size: Int) -> UIFont

    func icons(size: ThemeFontsSize) -> UIFont
    func icons(size: Int) -> UIFont
    func icons(size: CGFloat) -> UIFont
}
