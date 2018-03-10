//
//  VkAuthController.swift
//  UIServices
//
//  Created by Алексей on 10.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreTools
import CoreApiServices
import UITools

internal class VkAuthController: UIViewController {

    //UI
    private let service = WebBrowserController()
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    //Services
    private let authService = DependencyResolver.resolve(UserAuthApiService.self)
    private let apiKeys = DependencyResolver.resolve(ApiKeyService.self)
    private let configs = DependencyResolver.resolve(ConfigsContainer.self)
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)

    //Data
    private let _tag = String.tag(VkAuthController.self)
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

        service.delegate = self

        let url = "https://oauth.vk.com/authorize"
        let parameters: [String:String] = [
            "client_id": configs.get(ConfigKey.vkAppId)!,
            "scope": "65536", //offline
            "redirect_uri": "https://oauth.vk.com/blank.html",
            "display": "mobile",
            "v": "5.73",
            "response_type": "token"
        ]
        service.startLoad(url, parameters: parameters)

        service.setTitle(Localization.title.localized, textColor: UIColor.white, backgroundColor: themeColors.vkColor)
    }
}
extension VkAuthController: WebBrowserControllerDelegate {
    public func completeLoad(url: URL, parameters: [String : String]) {

        let path = url.absoluteString
        if (path.contains("blank.html")) {

            if let error = parameters["error"] {

                showToast(Localization.errorsVkAuth.localized)
                Log.warning(_tag, "Vk auth error: \(error)")

                onCancelTap()
                return
            }

            
            if let userIdSource = parameters["user_id"],
                    let userId = Long(userIdSource),
                    let token = parameters["access_token"] {

                service.showLoader()
                addUser(userId: userId, token: token)

                return
            }
        }
    }
    private func addUser(userId: Long, token: String) {

        let request = authService.viaVk(userId, token: token)
        request.async(loadQueue, completion: { response in

            if (response.isFail) {

                DispatchQueue.main.async {
                    self.navigationController?.alert(about: response)
                }
                self.onCancelTap()
                return
            }

            let keys = response.data!
            self.apiKeys.update(by: keys)
            self.handler.complete(success: true, keys: nil)
        })
    }
    public func onCancelTap() {
        navigationController?.popViewController(animated: true)
    }
}
extension VkAuthController {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(Localization.self)
        }
        public var bundle: Bundle {
            return Bundle.uiServices
        }

        case title = "Title"
        case cancelButton = "CancelButton"

        case errorsVkAuth = "Errors.VkAuth"
    }
}
extension ThemeColors {
    public var vkColor: UIColor {
        return UIColor(red: 76, green: 117, blue: 163)
    }
}
