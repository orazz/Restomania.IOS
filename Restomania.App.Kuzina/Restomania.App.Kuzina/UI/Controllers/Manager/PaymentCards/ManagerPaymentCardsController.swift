//
//  PaymentCardsController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import AsyncTask

public protocol IPaymentCardsDelegate {

    func removeCard(_: Long)
}
public class PaymentCardsController: UIViewController {

    private static let nibName = "ManagerPaymentCardsControllerView"
    public static func create() -> PaymentCardsController {

        let vc = PaymentCardsController(nibName: nibName, bundle: Bundle.main)

        return vc
    }

    //UI elements
    @IBOutlet weak var cardsTable: UITableView!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: RefreshControl!
    private var addCardUIService: AddCardUIService!

    // MARK: Tools
    private let _tag = String.tag(PaymentCardsController.self)
    private var loadQueue: AsyncQueue!

    // MARK: Data & service
    private var cardsService = CacheServices.cards
    private var cardsContainer: PartsLoadTypedContainer<[PaymentCard]>!
    private var loaderAdapter: PartsLoader!
    private let mainCurrency = CurrencyType.RUB

}
// MARK: Load circle
extension PaymentCardsController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: PaymentCardCell.nibName, bundle: nil)
        cardsTable.register(nib, forCellReuseIdentifier: PaymentCardCell.identifier)

        interfaceLoader = InterfaceLoader(for: view)
        refreshControl = cardsTable.addRefreshControl(for: self, action: #selector(needReload))
        addCardUIService = AddCardUIService()

        cardsContainer = PartsLoadTypedContainer<[PaymentCard]>(completeLoadHandler: self.completeLoad)
        cardsContainer.updateHandler = { update in
            DispatchQueue.main.async {
                self.cardsTable.reloadData()
            }
        }

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
        navigationItem.title = "Карты оплаты"
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hideNavigationBar()
    }

    private func loadData() {

        let cards = cardsService.cache.where { $0.Currency == self.mainCurrency }
        if (cards.isEmpty) {
            interfaceLoader.show()
        }

        requestCards()
    }
    @objc private func needReload() {
        requestCards()
    }
    private func requestCards() {
        cardsService.all().async(loadQueue, completion: cardsContainer.completeLoad)
    }
    private func completeLoad() {

        if (loaderAdapter.isLoad) {
            interfaceLoader.hide()
            refreshControl.endRefreshing()
        }
    }
}
// MARK: IPaymentCardsDelegate
extension PaymentCardsController: IPaymentCardsDelegate {

    @IBAction public func addCard() {

        Log.Debug(_tag, "Try add new payment card.")

        let currency = CurrencyType.RUB
        addCardUIService.addCard(for: currency, on: self) { success, _ in

            Log.Debug(self._tag, "Adding new card is \(success)")

            if (success) {
                DispatchQueue.main.async {
                    self.loadData()
                }
            }
        }
    }
    public func removeCard(_ cardId: Long) {

        Log.Debug(_tag, "Try remove #\(cardId) payment card.")

        guard var cards = cardsContainer.data,
              let index = cards.index(where: { cardId == $0.ID }) else {
            return
        }

        //Remove local
        let backup = cards
        cards.remove(at: index)
        cardsContainer.update(cards)

        //Remove remote
        let request = cardsService.remove(cardId)
        request.async(loadQueue) { response in
            if (response.isFail) {

                self.cardsContainer.update(backup)
                self.toast(for: response)
            }
        }
    }
}
// MARK: Table
extension PaymentCardsController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? PaymentCardCell
        cell?.Remove()
    }
}
extension PaymentCardsController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsContainer.data?.count ?? 0
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PaymentCardCell.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let card = cardsContainer.data![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCardCell.identifier, for: indexPath) as! PaymentCardCell
        cell.setup(card: card, delegate: self)

        return cell
    }
}
