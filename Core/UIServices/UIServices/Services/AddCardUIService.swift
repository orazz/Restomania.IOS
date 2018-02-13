//
//  AddCardUIService.swift
//  Kuzina
//
//  Created by Алексей on 12.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains
import CoreApiServices

public typealias AddPaymentCardCallback = ((Bool, Long) -> Void)
public class AddCardUIService: NSObject, UIWebViewDelegate {

    private let _webView: UIWebView
    private let _controller: UIViewController
    private let _loader: InterfaceLoader

    private let cardsApi: UserCardsApiService

    private var _isBusy: Bool = false
    private var _complete: AddPaymentCardCallback?
    private var cardId: Long?

    public init(_ cardsApi: UserCardsApiService) {

        self.cardsApi = cardsApi

        //Interface
        let screen = UIScreen.main.bounds
        _webView = UIWebView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))

        _controller = UIViewController()
        _controller.view.addSubview(_webView)

        _loader = InterfaceLoader(for: _controller.view)

        super.init()

        _webView.delegate = self
    }

    public func addCard(for currency: CurrencyType, on controller: UIViewController, complete: @escaping AddPaymentCardCallback) {

        if (_isBusy) {
            complete(false, 0)
            return
        }

        controller.present(_controller, animated: true, completion: nil)
        _isBusy = true
        _loader.show()
        _complete = { success, cardId in

            self._isBusy = false
            self._webView.stopLoading()
            self._controller.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                self._loader.hide()
            }

            complete(success, cardId)
        }

        let request = cardsApi.add(currency: currency)
        request.async(.background, completion: { response in

            if (!response.isSuccess) {
                self._complete?(false, 0)
                return
            }

            let addingCard = response.data!
            self.cardId = addingCard.ID
            let link = addingCard.link

            DispatchQueue.main.async {
                self._webView.loadRequest(URLRequest(url: URL(string: link)!))
            }
        })
    }

    // MARK: UIWebViewDelegate
    public func webViewDidFinishLoad(_ webView: UIWebView) {

        _loader.hide()
        if let url = webView.request?.url?.absoluteString {

            if (url.contains("restomania") &&
                url.contains("Payment") &&
                (url.contains("Success") || url.contains("Fail"))) {

                let result = url.contains("Success")
                _complete?(result, cardId!)

                return
            }
        }
    }
}
