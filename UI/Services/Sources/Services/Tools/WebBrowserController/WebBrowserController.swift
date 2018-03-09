//
//  WebBrowserController.swift
//  UIServices
//
//  Created by Алексей on 07.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreTools
import UITools

internal class WebBrowserController: UIViewController {

    //UI
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var titleItem: UINavigationItem!
    @IBOutlet private weak var cancelButtom: UIBarButtonItem!
    private var activityindicator: UIActivityIndicatorView!
    private var interfaceLoader: InterfaceLoader!
    @IBOutlet weak var webView: UIWebView!

    //Services
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)

    //Data
    private let delegate: WebBrowserControllerDelegate
    private var url: String
    private var parameters: [String:String]?
    private var pageTitle: String!
    private var navigationContentColor: UIColor!
    private var navigationBackgroundColor: UIColor!

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeColors.defaultStatusBar
    }


    internal init(delegate: WebBrowserControllerDelegate, for url: String, parameters: [String:String]? = nil) {

        self.delegate = delegate
        self.url = url
        self.parameters = parameters

        pageTitle = String.empty
        navigationContentColor = themeColors.navigationContent
        navigationBackgroundColor = themeColors.navigationMain

        super.init(nibName: String.tag(WebBrowserController.self), bundle: Bundle.uiServices)
    }
    internal convenience required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()

        startLoad(url, parameters: parameters)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setTitle(pageTitle, textColor: navigationContentColor, backgroundColor: navigationBackgroundColor)
    }
    private func loadMarkup() {

        interfaceLoader = InterfaceLoader(for: self.view)
        interfaceLoader.show()

        activityindicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityindicator.color = themeColors.navigationContent
        activityindicator.hidesWhenStopped = true
        titleItem.rightBarButtonItem = UIBarButtonItem(customView: activityindicator)
    }

    private func startLoad(_ url: String, parameters: [String:String]? = nil)  {

        guard let  components = NSURLComponents(string: url) else {
            return
        }

        components.queryItems = parameters?.flatMap({ URLQueryItem(name: $0.key, value: $0.value) })
        guard let url = components.url else {
            return
        }

        webView.loadRequest(URLRequest(url: url))
    }

    public func setTitle(_ title: String, textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {

        pageTitle = title
        navigationContentColor = textColor ?? navigationContentColor
        navigationBackgroundColor = backgroundColor ?? navigationBackgroundColor

        if nil == navigationBar  {
            return
        }

        titleItem.title = pageTitle

        if let textColor = textColor ?? navigationContentColor {
            navigationBar.tintColor = textColor
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: textColor]
        }

        if let backgroundColor = backgroundColor ?? navigationBackgroundColor {
            navigationBar.backgroundColor = backgroundColor
        }
    }
    public func setCancelButtom(_ title: String) {
        cancelButtom.title = title
    }

    public func showLoader() {
        interfaceLoader.show()
        activityindicator.startAnimating()
    }
    public func hideLoader() {
        interfaceLoader.hide()
        activityindicator.stopAnimating()
    }
    @IBAction private func cancelAction() {
        delegate.onCancelTap()
    }
}
extension WebBrowserController: UIWebViewDelegate {
    public func webViewDidStartLoad(_ webView: UIWebView) {

        showLoader()

        if let url = webView.request?.url {
            delegate.startLoad(url: url, parameters: url.queryParameters)
        }
    }
    public func webViewDidFinishLoad(_ webView: UIWebView) {

        hideLoader()

        if let url = webView.request?.url {
            delegate.completeLoad(url: url, parameters: url.queryParameters)
        }
    }
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {

        hideLoader()
        showToast(Keys.problemWithLoadMessage)

        if let url = webView.request?.url {
            delegate.failLoad(url: url, parameters: url.queryParameters, error: error)
        }
    }
}
extension WebBrowserController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(WebBrowserController.self)
        }
        public var bundle: Bundle {
            return Bundle.uiServices
        }

        case problemWithLoadMessage = "Errors.ProblemWithLoad.Message"
    }
}
extension URL {

    public var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems else {
            return [:]
        }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }

        return parameters
    }
}
