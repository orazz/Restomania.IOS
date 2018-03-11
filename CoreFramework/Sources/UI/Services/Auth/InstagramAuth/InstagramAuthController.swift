//
//  InstagramAuthController.swift
//  UIServices
//
//  Created by Алексей on 11.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

internal class InstagramAuthController: UIViewController {

    //UI
    private var service: WebBrowserController!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //Services
    private let authService = DependencyResolver.resolve(UserAuthApiService.self)
    private let apiKeys = DependencyResolver.resolve(ApiKeyService.self)
    private let configs = DependencyResolver.resolve(ConfigsContainer.self)
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)

    //Data
    private let _tag = String.tag(InstagramAuthController.self)
    private let redirectUrl = "http://restomania.azurewebsites.net/blank.html"
    private let loadQueue: AsyncQueue
    private let handler: AuthHandler

    internal init(_ handler: AuthHandler) {

        self.handler = handler
        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        super.init(nibName: nil, bundle: nil)
    }
    internal required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        //https://vk.com/dev/auth_mobile
        let url = "https://api.instagram.com/oauth/authorize/"
        let parameters: [String:String] = [
            "client_id": configs.get(ConfigKey.instagramAppId)!,
            "redirect_uri": redirectUrl,
            "response_type": "token"
        ]

        service = WebBrowserController(delegate: self, for: url, parameters: parameters)
        service.setTitle(Localization.title.localized, textColor: UIColor.white, backgroundColor: themeColors.instagramColor)
        present(service, animated: false, completion: nil)
    }
}
extension InstagramAuthController: WebBrowserControllerDelegate {
    public func completeLoad(url: URL, parameters: [String : String]) {

        let path = url.absoluteString
        if (path.starts(with: redirectUrl)) {

            if let error = parameters["error"] {

                navigationController?.showToast(Localization.errorsVkAuth.localized)
                Log.warning(_tag, "Instagram auth error: \(error)")
                Log.warning(_tag, "Instagram auth error: \(String(describing: parameters["error_description"]))")

                goBack()
                return
            }


            if let token = parameters["access_token"] {

                service.showLoader()
                addUser(token: token)

                return
            }
        }
    }
    private func addUser(token: String) {

        let request = authService.viaInstagram(token: token)
        request.async(loadQueue, completion: { response in

            if (response.isFail) {
                DispatchQueue.main.async {
                    self.goBack()
                    self.navigationController?.alert(about: response)
                }

                return
            }

            let keys = response.data!
            self.apiKeys.update(by: keys)
            self.handler.complete(success: true, keys: nil)
        })
    }
    private func goBack() {
        service.dismiss(animated: false, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    public func onCancelTap() {
        goBack()
    }
}
extension InstagramAuthController {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(InstagramAuthController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"
        case cancelButton = "CancelButton"

        case errorsVkAuth = "Errors.VkInstagram"
    }
}
extension ThemeColors {
    public var instagramColor: UIColor {
        return UIColor(red: 188, green: 42, blue: 141)
    }
}
