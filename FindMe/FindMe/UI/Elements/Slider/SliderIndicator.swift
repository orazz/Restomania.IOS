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

        _size = 0
        _isFocusOn = 0

        reDraw()
    }

    //MARK: Draw methods
    private func reDraw() {

    }


    //MARK: Focus methods
    public func focusTo(index: Int){

    }
    public func focusToNext() {

    }
    public func focusToPrev() {

    }


    private class Bullet: UIView {

        public static let side = CGFloat(12)

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

        public init(frame: CGRect, main: UIColor, focus: UIColor) {

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
            _shape.lineWidth = 3.0

            //Setup colors
            mainColor = main
            focusColor = focus

            super.init(frame: CGRect(x: frame.origin.x,
                                     y: frame.origin.y,
                                     width: Bullet.side,
                                     height: Bullet.side))

            self.layer.addSublayer(_shape)
        }
        public required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
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
