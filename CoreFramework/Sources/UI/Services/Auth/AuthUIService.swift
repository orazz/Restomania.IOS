//
//  AuthController.swift
//  CoreFramework
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public typealias AuthServiceCallback = ((Bool, ApiKeys?) -> Void)
public class AuthUIService {

    private let tag = String.tag(AuthUIService.self)
    private let guid = Guid.new

    //UI
    private var navigator: UINavigationController?

    //Services
    private let apiKeys: ApiKeyService

    //Data
    private var completeHandler: AuthServiceCallback?

    internal init(_ keys: ApiKeyService) {

        self.navigator = nil
        self.apiKeys = keys
        self.completeHandler = nil

        WebBrowserController.clearCache()

        keys.subscribe(guid: guid, handler: self, tag: tag)
    }

    fileprivate func show(on controller: UIViewController, completeHandler: AuthServiceCallback?) {

        self.completeHandler = completeHandler
        self.navigator = UINavigationController(rootViewController: SelectAuthController(for: self))

        controller.present(navigator!, animated: true, completion: nil)

        Log.info(tag, "Open auth service.")
    }
}
extension AuthUIService: AuthHandler {
    internal func complete(success: Bool, keys: ApiKeys?) {

        if let keys = keys {
            self.apiKeys.update(by: keys)
        }

        navigator?.popViewController(animated: false)
        navigator?.dismiss(animated: true, completion: nil)

        completeHandler?(success, keys)
    }
}
extension AuthUIService: ApiKeyServiceDelegate {
    public func apiKeyService(_ service: ApiKeyService, logout role: ApiRole) {
        WebBrowserController.clearCache()
    }
}
extension UIViewController {
    public func showAuth(complete: AuthServiceCallback? = nil) {

        let auth = DependencyResolver.get(AuthUIService.self)
        auth.show(on: self, completeHandler: complete)
    }
}
