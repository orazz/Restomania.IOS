//
//  ViewController.swift
//  IOSLibrary
//
//  Created by Алексей on 18.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    //MARK: Show
    open func modal(_ modal: UIViewController, animated: Bool, completion: Trigger? = nil) {
        
        modal.modalPresentationStyle = .overCurrentContext
        self.present(modal, animated: animated, completion: completion)
    }

    //MARK: Focus by scroll on active text field
    open func subscribeToScrollWhenKeyboardShow() {

        if (self.view is UIScrollView) {

            let center = NotificationCenter.default
            center.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            center.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    open func unsubscribefromScrollWhenKeyboardShow() {

        if (self.view is UIScrollView) {

            let center = NotificationCenter.default
            center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    @objc private func keyboardWasShown(notification: NSNotification){

        guard let scrollView = self.view as? UIScrollView else {
            return
        }

        let keyboardheight = prepareKeyboardHeight(for: notification)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardheight, 0.0)
        scrollView.isScrollEnabled = true
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        var rect = scrollView.frame
        rect.size.height -= keyboardheight
        if let activeSubview = searchActiveSubview(in: scrollView) {

            let frame = activeSubview.frame
            let top = scrollView.contentOffset.y
            let bottom = top + rect.height

            if (top > frame.origin.y || (frame.origin.y + frame.height) > bottom) {

                UIView.animate(withDuration: 0.5, animations: {

                    let offset = top + abs(bottom - frame.origin.y) + frame.height + CGFloat(10)
                    scrollView.contentOffset = CGPoint(x: 0, y: offset)
                })
            }
        }
    }
    @objc private func keyboardWillBeHidden(notification: NSNotification){

        guard let scrollView = self.view as? UIScrollView else {
            return
        }

        let keyboardheight = prepareKeyboardHeight(for: notification)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardheight, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.isScrollEnabled = false
        view.endEditing(true)
    }
    open func prepareKeyboardHeight(for notification: NSNotification) -> CGFloat {

        var info = notification.userInfo!
        return (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue.size.height * 1.1
    }
    private func searchActiveSubview(in parent: UIView) -> UIView? {

        for subview in parent.subviews {

            if let field = subview as? UITextField{
                if (field.isFirstResponder) {
                    return field
                }
            }
            else {

                if let _ = searchActiveSubview(in: subview) {
                    return subview
                }
            }
        }

        return nil
    }




    //MARK: Hide keyboard by tap by root view
    open func closeKeyboardWhenTapOnRootView(_ selector: Selector? = nil) -> TextFieldsStorage {

        let storage = TextFieldsStorage(vc: self)

        let tap = UITapGestureRecognizer(target: storage, action: #selector(storage.closeKeyboard))
        if let selector = selector {
            tap.addTarget(self, action: selector)
        }
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true

        return storage
    }
    open class TextFieldsStorage {

        public var fields: [UITextField]

        public init(vc: UIViewController) {

            self.fields = []

            collectFields(root: vc.view, range: &fields)
        }

        @objc public func closeKeyboard() {

            for field in fields {
                if (field.isFirstResponder) {
                    field.resignFirstResponder()
                }
            }
        }

        private  func collectFields(root: UIView, range: inout [UITextField]) {

            for subview in root.subviews {

                if (subview is UITextField) {
                    range.append(subview as! UITextField)
                }
                else {

                    collectFields(root: subview, range: &range)
                }
            }
        }
    }

}
