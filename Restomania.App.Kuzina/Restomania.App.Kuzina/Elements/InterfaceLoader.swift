//
//  Loader.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 27.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class InterfaceLoader {

    private let _parent: UIView
    private let _overlay: UIView
    private let _indicator: UIActivityIndicatorView
//    private let _blur: UIVisualEffectView

    public init(for parent: UIView) {

        _parent = parent
        _overlay = UIView(frame: parent.bounds)
        _overlay.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.55)

        _indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        let bounds = _indicator.bounds
        _indicator.center = CGPoint.init(x: parent.center.x - bounds.width/2, y: parent.center.y - bounds.height/2)

//        _blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
//        _blur.frame = parent.bounds
//        _blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]

//        _overlay.addSubview(_blur)
        _overlay.addSubview(_indicator)
    }

    public func show() {

        _indicator.startAnimating()
        _parent.addSubview(_overlay)
    }
    public func hide() {

        _indicator.stopAnimating()
        _overlay.removeFromSuperview()
    }
}
