//
//  SliderControl.swift
//  FindMe
//
//  Created by Алексей on 01.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

open class SliderIndicator: UIView {

    private var _size: Int = 0
    private var _isFocusOn: Int = 0
    private var _bullets:[Bullet] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialize()
    }
    private func initialize() {

        setup(size: 0)

    }
    public func setup(size: Int){

        _size = size
        _isFocusOn = 0

        reDraw()
    }

    //MARK: Draw methods
    private func reDraw() {

        for bullet in _bullets {
            bullet.removeFromSuperview()
        }
        _bullets = []

        if (0 == _size) {
            return
        }

        let size = CGFloat(_size)
        let bulletsWidth = size * Bullet.side + (size - 1) * Bullet.offset
        var x = (frame.width - bulletsWidth)/2
        let y = (frame.height - Bullet.side)/2
        for _ in 0..<_size {

            let bullet = Bullet(x: x, y: y, main: ThemeSettings.Colors.background, focus: ThemeSettings.Colors.bullet)
            _bullets.append(bullet)
            self.addSubview(bullet)
            x = x + Bullet.side + Bullet.offset
        }

        if let first = _bullets.first {
            first.focus()
        }
    }


    //MARK: Focus methods
    public func focusTo(index: Int){

        let next = fixIndex(index)

        for (index, element) in _bullets.enumerated() {

            if (index == next) {
                element.focus()
            }
            else {
                element.unfocus()
            }
        }
    }
    public func focusToNext() {
        focusTo(index: _isFocusOn + 1)
    }
    public func focusToPrev() {
        focusTo(index: _isFocusOn - 1)
    }
    private func fixIndex(_ next: Int) -> Int{

        return (next + _size) % _size
    }


    private class Bullet: UIView {

        public static let side = CGFloat(9)
        public static let offset = CGFloat(12)

        public var mainColor: UIColor {
            didSet{
                if (_isFocus){
                    focus()
                }
            }
        }
        public var focusColor: UIColor{
            didSet {
                if (!_isFocus){
                    unfocus()
                }
            }
        }

        private var _isFocus: Bool
        private let _shape: CAShapeLayer

        public init(x: CGFloat, y: CGFloat, main: UIColor, focus: UIColor) {

            _isFocus = false

            _shape = CAShapeLayer()
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: Bullet.side/2,y: Bullet.side/2),
                                          radius: Bullet.side/2,
                                          startAngle: CGFloat(0),
                                          endAngle:CGFloat(Double.pi * 2),
                                          clockwise: true)

            _shape.path = circlePath.cgPath
            _shape.fillColor = main.cgColor
            _shape.strokeColor = focus.cgColor
            _shape.lineWidth = 1.0

            //Setup colors
            mainColor = main
            focusColor = focus

            super.init(frame: CGRect(x: x,
                                     y: y,
                                     width: Bullet.side,
                                     height: Bullet.side))

            self.layer.addSublayer(_shape)
        }
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        //MARK: Methods
        public func focus() {

            if (_isFocus) {
                return
            }

            _isFocus = true

            UIView.animate(withDuration: 0.3, animations: {

                self._shape.fillColor = self.focusColor.cgColor
            })
        }
        public func unfocus(){

            if (!_isFocus){
                return
            }

            _isFocus = false

            UIView.animate(withDuration: 0.3, animations: {

                self._shape.fillColor = self.mainColor.cgColor
            })
        }

    }
}
