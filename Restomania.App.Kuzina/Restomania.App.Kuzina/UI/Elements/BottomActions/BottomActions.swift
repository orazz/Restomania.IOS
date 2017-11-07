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

    private let _parent: UIView
    private let _actions: UIView
    private var _content: UIView?
    private let _topContraint: NSLayoutConstraint

    public var container: UIView {
        return _actions
    }
    public var content: UIView? {
        return _content
    }

    public init(for view: UIView) {

        _parent = view
        _actions = UIView()
        _parent.addSubview(_actions)

        _actions.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: _actions, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: BottomActions.height)
        let top = NSLayoutConstraint(item: _actions, attribute: .top, relatedBy: .equal, toItem: _parent, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: _actions, attribute: .leading, relatedBy: .equal, toItem: _parent, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: _actions, attribute: .trailing, relatedBy: .equal, toItem: _parent, attribute: .trailing, multiplier: 1, constant: 0)

        NSLayoutConstraint.activate([height, left, right, top])

        _topContraint = top
    }

    public func show() {
        _topContraint.constant = -BottomActions.height
    }
    public func hide() {
        _topContraint.constant = 0
    }

    public func setup(content: UIView) {

        _actions.addSubview(content)
        content.frame = _actions.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        _content = content
    }
}
