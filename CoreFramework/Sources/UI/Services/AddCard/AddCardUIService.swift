//
//  AddCardUIService.swift
//  CoreFramework
//
//  Created by Алексей on 12.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public typealias AddPaymentCardCallback = ((Bool, Long?, PaymentCard?) -> Void)
public class AddCardUIService {

    private let tag = String.tag(AddCardUIService.self)
    private let cardsService: CardsCacheService
    private let service: WebBrowserController
    private var isBusy: Bool
    private var loadQueue: AsyncQueue

    private var cardId: Long?
    private var completeHandler: AddPaymentCardCallback?

    public init(_ cardsService: CardsCacheService) {

        self.cardsService = cardsService
        self.service = WebBrowserController()
        self.isBusy = false
        self.loadQueue = AsyncQueue.createForControllerLoad(for: tag)

        self.cardId = nil
        self.completeHandler = nil

        service.delegate = self
        service.setTitle(Localization.title.localized)
    }

    fileprivate func addCard(on controller: UIViewController, to paymentSystem: PaymentSystem?, complete: @escaping AddPaymentCardCallback) {

        if (isBusy) {
            complete(false, nil, nil)
            return
        }

        service.showLoader()
        WebBrowserController.clearCache()
        controller.present(service, animated: true, completion: nil)
        isBusy = true

        completeHandler = { success, cardId, card in

            self.isBusy = false
            self.cardId = nil
            self.completeHandler = nil

            DispatchQueue.main.async {
                self.service.dismiss(animated: true, completion: nil)
            }

            complete(success, cardId, card)
        }

        let request = cardsService.add(for: paymentSystem)
        request.async(loadQueue, completion: { response in

            if (response.isFail) {
                self.fail()
                return
            }

            let card = response.data!
            self.cardId = card.id

            DispatchQueue.main.async {
                self.service.startLoad(card.link)
            }
        })
    }
    private func fail() {
        completeHandler?(false, nil, nil)
    }
}
extension AddCardUIService: WebBrowserControllerDelegate  {
    public func completeLoad(url: URL, parameters: [String : String]) {

        let path = url.absoluteString

        if (path.contains("restomania") &&
            path.contains("Payment") &&
            (path.contains("Success") || path.contains("Fail"))) {

            let result = path.contains("Success")

            if (!result) {
                fail()
                return
            }

            requestCard()
        }
    }
    private func requestCard() {

        guard let cardId = cardId else {
            fail()
            return
        }

        let request = cardsService.find(cardId)
        request.async(loadQueue, completion: { response in

            if (response.isFail) {
                self.fail()
                return
            }

            let card = response.data!
            self.completeHandler?(true, cardId, card)
        })
    }
    func onCancelTap() {
        completeHandler?(false, nil, nil)
    }
}
extension AddCardUIService {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(AddCardUIService.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"
    }
}
extension UIViewController {
    public func show(_ service: AddCardUIService, to paymentSystem: PaymentSystem? = nil, complete: @escaping AddPaymentCardCallback) {
        service.addCard(on: self, to: paymentSystem, complete: complete)
    }
}
