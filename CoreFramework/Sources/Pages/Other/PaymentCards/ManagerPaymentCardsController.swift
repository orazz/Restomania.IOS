//
//  PaymentCardsController.swift
//  Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit 

public protocol IPaymentCardsDelegate {

    func removeCard(_: Long)
}
public class ManagerPaymentCardsController: UIViewController {

    //UI elements
    @IBOutlet weak var cardsTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: RefreshControl!
    private let addCardUIService = DependencyResolver.resolve(AddCardUIService.self)

    // MARK: Service
    private let configs = DependencyResolver.resolve(ConfigsContainer.self)
    private let cardsService = DependencyResolver.resolve(CardsCacheService.self)
    private var cardsContainer: PartsLoadTypedContainer<[PaymentCard]>!
    private var loaderAdapter: PartsLoader!

    // MARK: Tools
    private let _tag = String.tag(ManagerPaymentCardsController.self)
    private var loadQueue: AsyncQueue!

    public init() {
        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        super.init(nibName: String.tag(ManagerPaymentCardsController.self), bundle: Bundle.coreFramework)

        cardsContainer = PartsLoadTypedContainer<[PaymentCard]>(completeLoadHandler: self.completeLoad)
        cardsContainer.updateHandler = { update in
            DispatchQueue.main.async {
                self.cardsTable.reloadData()
            }
        }
        loaderAdapter = PartsLoader([cardsContainer])
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    public override func loadView() {
        super.loadView()

        ManagerPaymentCardCell.register(in: cardsTable)

        interfaceLoader = InterfaceLoader(for: view)
        refreshControl = cardsTable.addRefreshControl(for: self, action: #selector(needReload))

        addButton.setTitle(Keys.addButton.localized, for: .normal)
    }
}
// MARK: Load circle
extension ManagerPaymentCardsController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = Keys.title.localized
    }

    private func loadData() {

        let cards = cardsService.cache.where { $0.currency == self.configs.currency }
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
        let request = cardsService.all()
        request.async(loadQueue, completion: cardsContainer.completeLoad)
    }
    private func completeLoad() {
        DispatchQueue.main.async {

            if (self.loaderAdapter.isLoad) {
                self.interfaceLoader.hide()
                self.refreshControl.endRefreshing()

                if (self.loaderAdapter.problemWithLoad) {
                    self.showToast(Keys.loadError)
                }
            }
        }
    }
}
// MARK: IPaymentCardsDelegate
extension ManagerPaymentCardsController: IPaymentCardsDelegate {

    @IBAction public func addCard() {
        Log.debug(_tag, "Try add new payment card.")

        self.show(addCardUIService) { success, _, _ in

            Log.debug(self._tag, "Adding new card is \(success)")

            DispatchQueue.main.async {
                if (success) {
                    self.showToast(Keys.addSuccess)
                    self.loadData()
                } else {
                    self.showToast(Keys.addError)
                }
            }
        }
    }
    public func removeCard(_ cardId: Long) {

        Log.debug(_tag, "Try remove #\(cardId) payment card.")

        guard var cards = cardsContainer.data,
              let index = cards.index(where: { cardId == $0.id }) else {
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
                    self.showToast(Keys.removeError)
                }
            }
        }
    }
}
// MARK: Table
extension ManagerPaymentCardsController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? ManagerPaymentCardCell
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
        return ManagerPaymentCardCell.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let card = cardsContainer.data![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ManagerPaymentCardCell.identifier, for: indexPath) as! ManagerPaymentCardCell
        cell.setup(card: card, delegate: self)

        return cell
    }
}
extension ManagerPaymentCardsController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(ManagerPaymentCardsController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case addButton = "Buttons.Add"
        case loadError = "Messages.ProblemWithLoad"
        case addSuccess = "Messages.SuccessAdd"
        case addError = "Messages.ProblemWithAdd"
        case removeError = "Messages.ProblemWithRemove"
    }
}
