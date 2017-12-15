//
//  AuthController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public enum AuthPage {
    case login
    case signup
    case forgetPassword
}
public class AuthService {

    private let _tag = "AuthServiceController"

    private var _login: LoginController!
    private var _signup: SignupController!
    private var _forgetPassword: ForgetPasswordController!
    private var _controllers: [BaseAuthController] = []
    private var _navigator: UINavigationController
    private var _root: UIViewController

    private var _rights: ApiRole!
    private var _currentPage: AuthPage!

    private var _storage: KeysStorage!
    private var _complete: ((Bool) -> Void)?

    public init(open firstPage: AuthPage, with navigator: UINavigationController, rights: ApiRole) {

        _login = LoginController(nibName: LoginController.nibName, bundle: Bundle.main)
        _signup = SignupController(nibName: SignupController.nibName, bundle: Bundle.main)
        _forgetPassword = ForgetPasswordController(nibName: ForgetPasswordController.nibName, bundle: Bundle.main)

        _controllers = [_login, _signup, _forgetPassword]
        _navigator = navigator
        _root = navigator.topViewController!

        _rights = rights
        _currentPage = firstPage

        _storage = ToolsServices.shared.keys

        for controller in _controllers {
            controller.root = self
        }
    }
    public func show(complete: ((Bool) -> Void)? ) {

        _complete = complete

        let controller = take(for: _currentPage)
        _navigator.pushViewController(controller, animated: true)
        controller.authContainer = AuthContainer(login: String.empty, password: String.empty, rights: _rights)

        Log.Info(_tag, "Open auth pages.")
    }

    public func moveTo(_ page: AuthPage) {

        if (_currentPage == page) {
            return
        }

        let nextPage = take(for: page)
        let prevPage = take(for: _currentPage)
        nextPage.authContainer = prevPage.authContainer

        if (_navigator.viewControllers.contains(nextPage)) {

            _navigator.popToViewController(nextPage, animated: true)
        } else {

            _navigator.pushViewController(nextPage, animated: true)
        }

        _currentPage = page
    }
    private func take(for page: AuthPage) -> BaseAuthController {

        switch page {
        case .login:
            return _signup
//            return _login

        case .signup:
            return _signup

        case .forgetPassword:
            return _forgetPassword
        }
    }
    public func close() {

        if let done = _complete {

            done(nil != _storage.keys(for: _rights))
        }

        _navigator.popToViewController(_root, animated: true)
        Log.Info(_tag, "Close auth pages.")
    }
}
