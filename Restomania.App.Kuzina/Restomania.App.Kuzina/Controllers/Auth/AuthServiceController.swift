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
    case Login
    case Signup
    case ForgetPassword
}
public class AuthServiceController {

    private let _tag = "AuthServiceController"

    private var _login: LoginController!
    private var _signup: SignupController!
    private var _forgetPassword: ForgetPasswordController!
    private var _controllers: [BaseAuthController] = []
    private var _navigator: UINavigationController

    private var _rights: AccessRights!
    private var _currentPage: AuthPage!

    private var _storage: IKeysStorage!
    private var _complete: ((Bool) -> Void)?

    public init(open firstPage: AuthPage, with navigator: UINavigationController, rights: AccessRights) {

        _login = LoginController(nibName: LoginController.nibName, bundle: Bundle.main)
        _signup = SignupController(nibName: SignupController.nibName, bundle: Bundle.main)
        _forgetPassword = ForgetPasswordController(nibName: ForgetPasswordController.nibName, bundle: Bundle.main)

        _controllers = [_login, _signup, _forgetPassword]
        _navigator = navigator
        for controller in _controllers {
            controller.root = self
        }

        _rights = rights
        _currentPage = firstPage

        _storage = ServicesManager.current.keysStorage
    }
    public func show(complete: ((Bool) -> Void)? ) {

        _complete = complete

        let controller = take(for: _currentPage)
        _navigator.pushViewController(controller, animated: true)
        controller.setup(AuthContainer(login: String.Empty, password: String.Empty, rights: _rights))

        Log.Info(_tag, "Open auth pages.")
    }

    public func moveTo(_ page: AuthPage) {

        if (_currentPage == page) {
            return
        }

        let nextPage = take(for: page)
        let prevPage = take(for: _currentPage)
        nextPage.setup(prevPage.authContainer)

        _navigator.popViewController(animated: false)
        _navigator.pushViewController(nextPage, animated: true)

        _currentPage = page
    }
    private func take(for page: AuthPage) -> BaseAuthController {

        switch page {
        case .Login:
            return _login

        case .Signup:
            return _signup

        case .ForgetPassword:
            return _forgetPassword
        }
    }
    public func close() {

        if let done = _complete {

            var result = false

            if (nil != _storage.keysFor(rights: _rights)) {
                result = true
            }

            done(result)
        }

        _navigator.popViewController(animated: true)
        Log.Info(_tag, "Close auth pages.")
    }

//    override public func willMove(toParentViewController parent: UIViewController?) {
//        super.willMove(toParentViewController: parent)
//
//        print("fuck")
//    }
}
