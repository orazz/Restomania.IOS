//
//  PlaceCartController.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask
import IOSLibrary

public protocol PlaceCartContainerCell: InterfaceTableCellProtocol {

    func viewDidAppear()
    func viewDidDisappear()
    func updateData(with: PlaceCartDelegate)
}
public protocol PlaceCartDelegate {

    func takeCartContainer() -> PlaceCartController.CartContainer
    func takeSummary() -> PlaceSummary?
    func takeMenu() -> MenuSummary?
    func takeCart() -> Cart
    func takeCards() -> [PaymentCard]?
    func takeController() -> UIViewController

    func reloadInterface()
    func closePage()
    func addPaymentCard()
    func tryAddOrder()
}
public class PlaceCartController: UIViewController {

    //UI elements
    @IBOutlet private weak var navigationBarStubDimmer: UIView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var backNavigationItem: UIBarButtonItem!
    @IBOutlet private weak var interfaceTable: UITableView!
    private var interfaceLoader: InterfaceLoader!
    private var interfaceBuilder: InterfaceTable?
    private var interfaceParts: [PlaceCartContainerCell] = []
    private var refreshControl: RefreshControl!

    // MARK: Services
    private var addPaymentCardsService = AddCardUIService()
    private var keysService = ToolsServices.shared.keys
    private var ordersApi = ApiServices.Users.orders

    // MARK: Data
    private let _tag = String.tag(PlaceCartController.self)
    private var loadQueue: AsyncQueue!
    private var placeId: Long!
    private var cart: Cart!
    private var cartContaier: CartContainer!

    // MARK: Loading
    private var summaryContainer: PartsLoadTypedContainer<PlaceSummary>!
    private var menuContainer: PartsLoadTypedContainer<MenuSummary>!
    private var cardsContainer: PartsLoadTypedContainer<[PaymentCard]>!
    private var placesCache = CacheServices.places
    private var menusCache = CacheServices.menu
    private var cardsCache = CacheServices.cards
    private var loadAdapter: PartsLoader!

    public init(for placeId: Long) {
        super.init(nibName: "PlaceCartControllerView", bundle: Bundle.main)

        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        self.placeId = placeId
        self.cart = ToolsServices.shared.cart(for: placeId)
        self.cartContaier = CartContainer(for: placeId, with: cart)

        summaryContainer = PartsLoadTypedContainer<PlaceSummary>()
        menuContainer = PartsLoadTypedContainer<MenuSummary>()
        cardsContainer = PartsLoadTypedContainer<[PaymentCard]>()
        loadAdapter = PartsLoader([summaryContainer, menuContainer, cardsContainer])
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: Actions
extension PlaceCartController {
    @IBAction private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: View life circle
extension PlaceCartController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        interfaceLoader = InterfaceLoader(for: self.view)

        interfaceParts = loadRows()
        interfaceBuilder = InterfaceTable(source: interfaceTable, navigator: self.navigationController!, rows: interfaceParts)
        refreshControl = interfaceTable.addRefreshControl(for: self, action: #selector(needReload))

        loadMarkup()
        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        trigger({ $0.viewDidAppear() })
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        trigger({ $0.viewDidDisappear() })
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private func loadMarkup() {

        navigationBarStubDimmer.backgroundColor = ThemeSettings.Colors.main
        navigationBar.barTintColor = ThemeSettings.Colors.main

        let backButton = backNavigationItem.customView as! UIButton
        let size = CGFloat(35)
        let back = UIImageView(image: ThemeSettings.Images.navigationBackward)
        back.frame = CGRect(x: -11, y: 0 /*backButton.center.y - size/2*/, width: size, height: size)
        backButton.addSubview(back)
    }
}

// MARK: InterfaceTable
extension PlaceCartController {
    private func trigger(_ action: @escaping ((PlaceCartContainerCell) -> Void)) {

        DispatchQueue.main.async {
            for cell in self.interfaceParts {
                action(cell)
            }
        }
    }
    private func loadRows() -> [PlaceCartContainerCell] {

        var result = [PlaceCartContainerCell]()

        //Date picker
        result.append(PlaceCartDateContainer.create(for: self))
        result.append(PlaceCartDivider.create())

        //Dishes
        result.append(PlaceCartDishesContainer.create(for: self))
        result.append(PlaceCartDivider.create())

        //Total check
        result.append(PlaceCartTotalContainer.create(for: self))
        result.append(PlaceCartDivider.create())

        //Payment cards
        result.append(PlaceCartPaymentCardsContainer.create(with: self))
        result.append(PlaceCartDivider.create())

        //Comment and takeaway
//        result.append(PlaceCartAdditionalContainer.create(for: self))
//        result.append(PlaceCartDivider.create())

        //Complete
        result.append(PlaceCartDivider.create())
        result.append(PlaceCartCompleteOrderContainer.create(for: self))

        return result
    }
}

//MARk: Load data
extension PlaceCartController {

    private func loadData() {
        if (!keysService.isAuth(for: .user)) {
            closePage()
            return
        }

        if let data = placesCache.cache.find(placeId) {
            self.summaryContainer.update(data)
            self.summaryContainer.completeLoad()
        }

        if let menu = menusCache.findLocal(by: placeId, summary: self.summaryContainer.data) {
            self.menuContainer.update(menu)
            self.menuContainer.completeLoad()
        }

        self.cardsContainer.update(cardsCache.cache.all)

        if (loadAdapter.noData) {
            interfaceLoader.show()
        }

        requestData()
    }
    @objc private func needReload() {

        loadAdapter.startRequest()

        requestData()
    }
    private func requestData() {

        if (!summaryContainer.isLoad) {
            requestSummary()
        }

        if (!menuContainer.isLoad) {
            requestMenu()
        }

        requestCards()
    }
    private func requestSummary() {
        let request = placesCache.find(placeId)
        request.async(loadQueue, completion: summaryContainer.completeLoad)
    }
    private func requestMenu() {
        let request = menusCache.find(placeId)
        request.async(loadQueue, completion: menuContainer.completeLoad)
    }
    private func requestCards() {
        let request = cardsCache.all()
        request.async(loadQueue, completion: cardsContainer.completeLoad)
    }
    private func completeLoad() {
        DispatchQueue.main.async {

            if (self.loadAdapter.isFail) {
                Log.Error(self._tag, "Problem with load data for page.")

                self.closePage()
                self.navigationController?.toast(title: Localization.Alerts.LoadError.Title.localized,
                                                message: Localization.Alerts.LoadError.Message.localized)

                return
            }

            self.trigger({ $0.updateData(with: self) })

            if (self.loadAdapter.isLoad) {
                self.interfaceLoader.hide()
                self.refreshControl.endRefreshing()
            }

            self.reloadInterface()
        }
    }
}

// MARK: PlaceCartDelegate
extension PlaceCartController: PlaceCartDelegate {

    public func takeCartContainer() -> PlaceCartController.CartContainer {
        return cartContaier
    }
    public func takeSummary() -> PlaceSummary? {
        return summaryContainer.data
    }
    public func takeMenu() -> MenuSummary? {
        return menuContainer.data
    }
    public func takeCart() -> Cart {
        return cart
    }
    public func takeCards() -> [PaymentCard]? {

        if let menu = takeMenu() {
            return cardsContainer.data?.where({ $0.Currency == menu.currency })
        } else {
            return cardsContainer.data
        }
    }
    public func takeController() -> UIViewController {
        return self
    }

    public func reloadInterface() {
        interfaceBuilder?.reload()
    }
    public func closePage() {
        goBack()
    }
    public func addPaymentCard() {

        guard let menu = takeMenu() else {
            return
        }

        addPaymentCardsService.addCard(for: menu.currency, on: self) { success, result in
            DispatchQueue.main.sync {

                if (!success) {
                    self.toast(title: Localization.Alerts.AddPaymentCard.Title,
                              message: Localization.Alerts.AddPaymentCard.Message)

                    return
                } else {
                    self.interfaceLoader.show()
                }
            }

            let request = self.cardsCache.find(result)
            request.async(self.loadQueue) { response in
                DispatchQueue.main.async {

                    if let card = response.data {
                        self.cardsContainer.update([card] + self.cardsCache.cache.all)
                        self.cartContaier.cardId = card.ID

                        self.trigger({ $0.updateData(with: self) })
                    } else if (response.isFail) {
                        self.toast(for: response)
                    }

                    self.interfaceLoader.hide()
                }
            }
        }
    }
    public func tryAddOrder() {
        Log.Info(_tag, "Try add order.")

        interfaceLoader.show()

        let request = ordersApi.add(order: cartContaier.prepareOrder())
        request.async(loadQueue) { response in

            DispatchQueue.main.async {

                if response.isSuccess,
                    let order = response.data {

                    let vc = PlaceCompleteOrderController.create(for: order)
                    self.navigationController?.pushViewController(vc, animated: true)

                    Log.Debug(self._tag, "Add order to #\(self.placeId)")
                }

                if (response.isFail) {
                    if (response.statusCode == .BadRequest) {
                        self.toast(title: Localization.Alerts.AddOrder.Title,
                                 message: Localization.Alerts.AddOrder.Message)
                    } else {
                        self.toast(for: response)
                    }

                    Log.Warning(self._tag, "Problem with add order.")
                }

                self.interfaceLoader.hide()
            }
        }
    }

    public class CartContainer {

        public let placeId: Long
        public var cardId: Long?
        public var isValidDateTime: Bool = false

        private let cart: Cart

        public init(for placeId: Long, with cart: Cart) {
            self.placeId = placeId
            self.cart = cart
        }

        public var comment: String {
            get {
                return cart.comment
            }
            set {
                cart.comment = newValue
            }
        }
        public var takeaway: Bool {
            get {
                return cart.takeaway
            }
            set {
                cart.takeaway = newValue
            }
        }
        public func prepareOrder() -> AddedOrder {
            return cart.build(cardId: cardId!)
        }
    }
}

extension PlaceCartController {

    public class Localization {
        private static let tablename = "PlaceCartController"

        public enum Keys: String, Localizable {

            case Title = "Title"

            public var tableName: String {
                return Localization.tablename
            }
        }
        public class Alerts {
            public enum AddPaymentCard: String, Localizable {
                public var tableName: String {
                    return Localization.tablename
                }

                case Title = "Alerts.AddPaymentCard.Title"
                case Message = "Alerts.AddPaymentCard.Message"
            }
            public enum AddOrder: String, Localizable {
                public var tableName: String {
                    return Localization.tablename
                }

                case Title = "Alerts.AddOrder.Title"
                case Message = "Alerts.AddOrder.Message"
            }
            public enum LoadError: String, Localizable {
                public var tableName: String {
                    return Localization.tablename
                }

                case Title = "Alerts.LoadError.Title"
                case Message = "Alerts.LoadError.Message"
            }
        }
    }
}
