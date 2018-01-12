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
import Toast_Swift

public protocol IPaymentCardsDelegate {

    func removeCard(_: Long)
}
public class ManagerPaymentCardsController: UIViewController {

    private static let nibName = "ManagerPaymentCardsControllerView"
    public static func create() -> ManagerPaymentCardsController {

        let vc = ManagerPaymentCardsController(nibName: nibName, bundle: Bundle.main)

        return vc
    }

    //UI elements
    @IBOutlet weak var cardsTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: RefreshControl!
    private var addCardUIService: AddCardUIService!

    // MARK: Tools
    private let _tag = String.tag(ManagerPaymentCardsController.self)
    private var loadQueue: AsyncQueue!

    // MARK: Data & service
    private var cardsService = CacheServices.cards
    private var cardsContainer: PartsLoadTypedContainer<[PaymentCard]>!
    private var loaderAdapter: PartsLoader!
    private let mainCurrency = CurrencyType.RUB

}
// MARK: Load circle
extension ManagerPaymentCardsController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: PaymentCardCell.nibName, bundle: nil)
        cardsTable.register(nib, forCellReuseIdentifier: PaymentCardCell.identifier)

        interfaceLoader = InterfaceLoader(for: view)
        refreshControl = cardsTable.addRefreshControl(for: self, action: #selector(needReload))
        addCardUIService = AddCardUIService()

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        cardsContainer = PartsLoadTypedContainer<[PaymentCard]>(completeLoadHandler: self.completeLoad)
        cardsContainer.updateHandler = { update in
            DispatchQueue.main.async {
                self.cardsTable.reloadData()
            }
        }

        loaderAdapter = PartsLoader([cardsContainer])

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
        navigationItem.title = Keys.title.localized
        addButton.setTitle(Keys.addButton.localized, for: .normal)
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hideNavigationBar()
    }

    private func loadData() {

        let cards = cardsService.cache.where { $0.Currency == self.mainCurrency }
        if (cards.isEmpty) {
            interfaceLoader.show()
        } else {
            cardsContainer.update(cards)
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
        DispatchQueue.main.async {

            if (self.loaderAdapter.isLoad) {
                self.interfaceLoader.hide()
                self.refreshControl.endRefreshing()
            }

            if (!self.cardsContainer.isSuccessLastUpdate) {
                self.view.makeToast(Keys.loadError.localized, style: ThemeSettings.Elements.toast)
            }
        }
    }
}
// MARK: IPaymentCardsDelegate
extension ManagerPaymentCardsController: IPaymentCardsDelegate {

    @IBAction public func addCard() {
        Log.Debug(_tag, "Try add new payment card.")

        addCardUIService.addCard(for: self.mainCurrency, on: self) { success, _ in

            Log.Debug(self._tag, "Adding new card is \(success)")

            DispatchQueue.main.async {
                if (success) {
                    self.loadData()
                    self.view.makeToast(Keys.addSuccess.localized, style: ThemeSettings.Elements.toast)
                } else {
                    self.view.makeToast(Keys.addError.localized, style: ThemeSettings.Elements.toast)
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
                DispatchQueue.main.async {
                    self.view.makeToast(Keys.removeError.localized, style: ThemeSettings.Elements.toast)
                }
            }
        }
    }
}
// MARK: Table
extension ManagerPaymentCardsController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? PaymentCardCell
        cell?.Remove()
    }
}
extension ManagerPaymentCardsController: UITableViewDataSource {
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
extension ManagerPaymentCardsController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(ManagerPaymentCardsController.self)
        }

        case title = "Title"

        case addButton = "Buttons.Add"
        case loadError = "Messages.ProblemWithLoad"
        case addSuccess = "Messages.SuccessAdd"
        case addError = "Messages.ProblemWithAdd"
        case removeError = "Messages.ProblemWithRemove"
    }
}
