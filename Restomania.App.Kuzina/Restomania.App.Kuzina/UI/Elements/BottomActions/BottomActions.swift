//
//  BottomActions.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class BottomActions {

    public static let height = CGFloat(50)

    private let parent: UIView
    private let actions: UIView
    private let topContraint: NSLayoutConstraint

    public init(for view: UIView) {

        parent = view
        actions = UIView()
        parent.addSubview(actions)

        let height = NSLayoutConstraint(item: actions,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: BottomActions.height)

        let left = NSLayoutConstraint(item: actions,
                                      attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: parent,
                                      attribute: .leading,
                                      multiplier: 1,
                                      constant: 0)

        let right = NSLayoutConstraint(item: actions,
                                       attribute: .trailing,
                                       relatedBy: .equal,
                                       toItem: parent,
                                       attribute: .trailing,
                                       multiplier: 1,
                                       constant: 0)

        topContraint = NSLayoutConstraint(item: actions,
                                          attribute: .top,
                                          relatedBy: .equal,
                                          toItem: parent,
                                          attribute: .bottom,
                                          multiplier: 1,
                                          constant: 0)

        NSLayoutConstraint.activate([height, left, right, topContraint])
    }

    public func show() {
        topContraint.constant = -BottomActions.height
    }
    public func hide() {
        topContraint.constant = 0
    }

    public func setup(content: UIView) {

        actions.addSubview(content)
        content.frame = actions.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
