//
//  AuthController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit
import CoreTools
import CoreDomains

public class AuthUIService {

    private let tag = String.tag(AuthUIService.self)

    private var _signup: SignupController!
    private var _forgetPassword: ForgetPasswordController!
    private var _controllers: [BaseAuthController] = []
    private var _navigator: UINavigationController
    private var _root: UIViewController

    private var authKeys: ApiKeyService!
    private var _complete: ((Bool) -> Void)?

    public init(_ keys: ApiKeyService) {

        authKeys = keys

        _signup = SignupController()
        _forgetPassword = ForgetPasswordController()

        _controllers = [_signup, _forgetPassword]
        _root = UIViewController()
        _navigator = UINavigationController(rootViewController: _root)

//        _currentPage = firstPage

//        for controller in _controllers {
//            controller.root = self
//        }
    }
    public var isAuth: Bool {
        return authKeys.isAuth
    }
    public func show(on controller: UIViewController, complete: ((Bool) -> Void)? = nil ) {

        _complete = complete

        controller.present(_navigator, animated: false, completion: nil)
//
//        let controller = take(for: _currentPage)
//        _navigator.pushViewController(controller, animated: true)
//        controller.authContainer = AuthContainer(login: String.empty, password: String.empty)

        Log.info(tag, "Open auth pages.")
    }

//    public func moveTo(_ page: AuthPage) {

//        if (_currentPage == page) {
//            return
//        }
//
//        let nextPage = take(for: page)
////        let prevPage = take(for: _currentPage)
//        nextPage.authContainer = prevPage.authContainer
//
//        if (_navigator.viewControllers.contains(nextPage)) {
//
//            _navigator.popToViewController(nextPage, animated: true)
//        } else {
//
//            _navigator.pushViewController(nextPage, animated: true)
//        }
//
//        _currentPage = page
//    }
//    private func take() -> BaseAuthController {
//
//        switch page {
//        case .signup:
//            return _signup
//
//        case .forgetPassword:
//            return _forgetPassword
//        }
//    }
    public func close() {

//        _complete?(authKeys.isAuth)
//
//        _navigator.popToViewController(_root, animated: true)
//        Log.info(tag, "Close auth pages.")
    }
}
extension UIViewController {
    public func show(_ auth: AuthUIService, complete: ((Bool) -> Void)? = nil) {
        auth.show(on: self, complete: complete)
    }
}
