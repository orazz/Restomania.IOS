//
//  VKAuthorizationController.swift
//  FindMe
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import IOSLibrary

public class VKAuthorizationController: UIViewController, WKNavigationDelegate {
    public typealias Handler = (Bool, VKAuthorizationResult?) -> Void

    private static let nibName = "VKAuthorizationView"
    public static func build(callback: @escaping Handler) -> VKAuthorizationController
    {
        let instance = VKAuthorizationController.init(nibName: nibName, bundle: Bundle.main)

        instance._keys = ServicesFactory.shared.keys
        instance._auth = UsersAuthApiService()
        instance._callback = callback
        instance._appID = ServicesFactory.shared.configs.get(forKey: ConfigsKey.vkAppID).value as! Int

        return instance
    }

    //MARK: UIElements
    @IBOutlet weak var NavigationBar: UINavigationBar!
    private var _loader: InterfaceLoader!
    private var _webView: WKWebView!

    //MARK: Data & Services
    private let _tag = String.tag(VKAuthorizationController.self)
    private var _keys: IKeysStorage!
    private var _auth: UsersAuthApiService!
    private var _callback: Handler!
    private var _appID: Int!


    //MARK: Controller circle
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        initElements()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initElements()
    }
    private func initElements() {

        _loader = InterfaceLoader(for: self.view)
        _webView = WKWebView(frame: CGRect(x: 0,
                                           y: NavigationBar.frame.height,
                                           width: self.view.frame.width,
                                           height: self.view.frame.height - NavigationBar.frame.height))
        self.view.addSubview(_webView)
    }
    public override func viewDidLoad() {

        Log.Info(_tag, "Load auth controller.")

        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.setToolbarHidden(true, animated: false)

        _webView.navigationDelegate = self
        _webView.load(URLRequest(url: prepareAuthUrl()))
        _loader.show()

        NavigationBar.backgroundColor = ThemeSettings.Colors.vk

        super.viewWillAppear(animated)
    }
    private func prepareAuthUrl() -> URL {

        let url = "https://oauth.vk.com/authorize"

        var parameters = [String]()
        parameters.append("client_id=\(_appID!)")
        parameters.append("scope=\(VKPermissions.prepare(.offline, .email))")
        parameters.append("redirect_uri=https://oauth.vk.com/blank.html")
        parameters.append("display=mobile")
        parameters.append("v=5.68")
        parameters.append("response_type=token")

        let builded = parameters.joined(separator: "&")

        return URL(string: "\(url)?\(builded)")!
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        _webView.stopLoading()
        _webView.navigationDelegate = nil
    }
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        _loader.hide()
    }
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction public func cancelLoad() {
        self.dismiss(animated: true, completion: nil)

        self._callback(false, nil)
    }



    //MARK: WKNavigationDelegate
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        Log.Debug(_tag, "Web view navigate to \(String(describing: webView.url?.absoluteString))")

        _loader.hide()

        if let url = webView.url,
            url.absoluteString.starts(with: "https://oauth.vk.com/blank.html") {

            self.completeAuth(url: url.absoluteString)
            _loader.show()
            webView.stopLoading()
        }
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        Log.Warning(_tag, "Problem with auth via vk.")
        Log.Warning(_tag, "Error: \(error)")

        showAlertAndClose()
    }
    private func completeAuth(url: String) {

        let container = VKAuthorizationResult(url: url)

        if (!container.success) {
            showAlertAndClose()
            return
        }

        let task = _auth.vk(userId: container.userId, token: container.accessToken, expireIn: container.expiresIn)
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                if (response.isFail) {
                    self.showAlertAndClose()
                    return
                }

                let keys = response.data!
                self._keys.set(for: .user, keys: keys)
                self._callback(true, container)
            }
        })

    }
    private func showAlertAndClose() {

        let alert = UIAlertController(title: "Error", message: "Проблемы с авторизацией через vk.com. Попробуйте позднее.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.cancelLoad()
        }))

        self.show(alert, sender: nil)
    }



    public class VKAuthorizationResult {

        private struct Keys {

            public static let accessToken = "access_token"
            public static let expiresIn = "expires_in"
            public static let userId = "user_id"

            public static let error = "error"
            public static let errorDescription = "rror_description"
        }

        public let success: Bool
        public var accessToken: String = String.empty
        public var expiresIn: Long = 0
        public var userId: Long = 0

        public var error: String = String.empty
        public var errorDescription: String = String.empty

        public init(url: String) {

            //Success
            //http://REDIRECT_URI#access_token=533bacf01e11f55b536a565b57531ad114461ae8736d6506a3&expires_in=86400&user_id=8492
            //Fail
            //http://REDIRECT_URI?error=access_denied&error_description=The+user+or+authorization+server+denied+the+request.

            self.success = url.contains(Keys.accessToken)

            let parameters = url.characters.split(whereSeparator:  {  "?#&".contains($0) })
                                            .map(String.init)
            for pair in parameters {

                if (pair.contains(Keys.accessToken)) {

                    accessToken = getValue(pair: pair)
                }
                else if (pair.contains(Keys.expiresIn)) {

                    expiresIn = Long(getValue(pair: pair)) ?? 0
                }
                else if (pair.contains(Keys.userId)) {

                    userId = Long(getValue(pair: pair)) ?? 0
                }
                else if (pair.contains(Keys.error)) {

                    error = getValue(pair: pair)
                }
                else if (pair.contains(Keys.errorDescription)) {

                    errorDescription = getValue(pair: pair)
                }
            }
        }
        private func getValue(pair: String) -> String {

            if let range = pair.range(of: "=") {

                return pair.substring(from: range.upperBound)
                            .trimmingCharacters(in: .whitespacesAndNewlines)
            }

            return String.empty
        }
    }
    public enum VKPermissions: Int {

        case offline = 65536
        case email = 4194304

        public static func prepare(_ permissims: VKPermissions ...) -> Long {

            var result = Long(0)
            for p in permissims {
                result = result + Long(p.rawValue)
            }

            return result
        }
    }
}
