//
//  PlaceCartController.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public protocol PlaceCartContainerCell: InterfaceTableCellProtocol {

    func viewDidAppear()
    func viewDidDisappear()
    func updateData(with: PlaceCartDelegate)
}
public protocol PlaceCartDelegate {

    func takeCartContainer() -> PlaceCartController.CartContainer
    func takeSummary() -> PlaceSummary?
    func takeMenu() -> MenuSummary?
    func takeCart() -> CartService
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

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)
    private let themeImages = DependencyResolver.resolve(ThemeImages.self)

    // MARK: Services
    private var addPaymentCardsService = DependencyResolver.resolve(AddCardUIService.self)
    private var keysService = DependencyResolver.resolve(ApiKeyService.self)
    private var ordersService = DependencyResolver.resolve(OrdersCacheService.self)
    private var placesService = DependencyResolver.resolve(PlacesCacheService.self)
    private var menusService = DependencyResolver.resolve(MenuCacheService.self)
    private var cardsService = DependencyResolver.resolve(CardsCacheService.self)

    // MARK: Data
    private let _tag = String.tag(PlaceCartController.self)
    private var loadQueue: AsyncQueue!
    private var placeId: Long!
    private var cart: CartService!
    private var cartContaier: CartContainer!

    // MARK: Loading
    private var summaryContainer: PartsLoadTypedContainer<PlaceSummary>!
    private var menuContainer: PartsLoadTypedContainer<MenuSummary>!
    private var cardsContainer: PartsLoadTypedContainer<[PaymentCard]>!
    private var loadAdapter: PartsLoader!

    public init(for placeId: Long) {
        super.init(nibName: "PlaceCartControllerView", bundle: Bundle.coreFramework)

        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        self.placeId = placeId
        self.cart = DependencyResolver.resolve(PlaceCartsFactory.self).get(for: placeId)
        self.cartContaier = CartContainer(for: placeId, with: cart)

        //Loaders
        summaryContainer = PartsLoadTypedContainer<PlaceSummary>(completeLoadHandler: self.completeLoad)
        summaryContainer.updateHandler = { _ in
            self.notifyAboutUpdateData()
        }
        menuContainer = PartsLoadTypedContainer<MenuSummary>(completeLoadHandler: self.completeLoad)
        menuContainer.updateHandler = { _ in
            self.notifyAboutUpdateData()
        }
        cardsContainer = PartsLoadTypedContainer<[PaymentCard]>(completeLoadHandler: self.completeLoad)
        cardsContainer.updateHandler = { _ in
            self.notifyAboutUpdateData()
        }

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

        navigationBarStubDimmer.backgroundColor = themeColors.navigationMain
        navigationBar.barTintColor = themeColors.navigationMain
        navigationBar.topItem?.title = Localization.Labels.title.localized

        let backButton = backNavigationItem.customView as! UIButton
        let size = CGFloat(35)
        let icon = themeImages.iconBack.tint(color: themeColors.navigationContent)
        let back = UIImageView(image: icon)
        back.frame = CGRect(x: -11, y: 0 /*backButton.center.y - size/2*/, width: size, height: size)
        backButton.addSubview(back)

        reloadInterface()
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
        result.append(PlaceCartTotalContainer.create(for: self))
        result.append(PlaceCartDivider.create())

        //Payment cards
        result.append(PlaceCartPaymentCardsContainer.create(with: self))
        result.append(PlaceCartDivider.create())

        //Comment and takeaway
        result.append(PlaceCartAdditionalContainer.create(for: self))
        result.append(PlaceCartDivider.create())

        //Complete
        result.append(PlaceCartDivider.create())
        result.append(PlaceCartCompleteOrderContainer.create(for: self))

        return result
    }
}

//MARk: Load data
extension PlaceCartController {

    private func loadData() {
        if (!keysService.isAuth) {
            closePage()
            return
        }

        if let summary = placesService.cache.find(placeId) {
            summaryContainer.updateAndCheckFresh(summary, cache: placesService.cache)
        }

        if let menu = menusService.cache.find(by: placeId, summary: self.summaryContainer.data) {
            menuContainer.updateAndCheckFresh(menu, cache: menusService.cache)
        }

        self.cardsContainer.update(cardsService.cache.all)

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
        let request = placesService.find(placeId)
        request.async(loadQueue, completion: summaryContainer.completeLoad)
    }
    private func requestMenu() {
        let request = menusService.find(placeId)
        request.async(loadQueue, completion: menuContainer.completeLoad)
    }
    private func requestCards() {
        let request = cardsService.all()
        request.async(loadQueue, completion: cardsContainer.completeLoad)
    }
    private func completeLoad() {

        if (self.loadAdapter.isLoad) {
            DispatchQueue.main.async {

                self.interfaceLoader.hide()
                self.refreshControl.endRefreshing()

                if (self.loadAdapter.problemWithLoad) {
                    self.showToast(Localization.Toasts.problemWithLoad)
                    Log.error(self._tag, "Problem with load data for page.")
                }
            }
        }
    }
    private func notifyAboutUpdateData() {
        DispatchQueue.main.async {
            self.trigger({ $0.updateData(with: self) })
            self.reloadInterface()
        }
    }
    private func filterCards() {

        if let menu = menuContainer.data,
            let cards = cardsContainer.data {
            cardsContainer.update(cards.filter({ $0.currency == menu.currency }))
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
    public func takeCart() -> CartService {
        return cart
    }
    public func takeCards() -> [PaymentCard]? {

        if let menu = takeMenu() {
            return cardsContainer.data?.where({ $0.currency == menu.currency })
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

        guard let summary = takeSummary() else {
            return
        }

        self.show(addPaymentCardsService, to: summary.paymentSystem) { success, cardId, _ in

            DispatchQueue.main.async {

                if (!success) {
                    self.showToast(Localization.Toasts.problemWithAddCard)
                    return
                }

                self.cartContaier.cardId = cardId
                self.cardsContainer.update(self.cardsService.cache.all)

                self.trigger({ $0.updateData(with: self) })
                self.reloadInterface()
            }
        }
    }
    public func tryAddOrder() {
        Log.info(_tag, "Try add order.")

        guard let _ = cartContaier.cardId else {
            self.showToast(Localization.Toasts.needSelectPaymentCard)
            return
        }

        guard let summary = takeSummary() else {
            return
        }

        let order = cartContaier.prepareOrder()
        if (!summary.Schedule.canOrder(on: order.completeAt)) {
            self.showToast(Localization.Toasts.notWorkTime)
            return
        }

        interfaceLoader.show()

        let request = ordersService.add(order)
        request.async(loadQueue) { response in

            DispatchQueue.main.async {

                if response.isSuccess,
                    let order = response.data {

                    let vc = PlaceCompleteOrderController.create(for: order)
                    self.navigationController?.pushViewController(vc, animated: true)

                    Log.debug(self._tag, "Add order #\(self.placeId)")
                }

                if (response.isFail) {
                    if (response.statusCode == .BadRequest) {
                        self.showToast(Localization.Toasts.badAddOrder)
                    } else {
                        self.alert(about: response)
                    }

                    Log.warning(self._tag, "Problem with add order.")
                }

                self.interfaceLoader.hide()
            }
        }
    }

    public class CartContainer {

        public let placeId: Long
        public var cardId: Long?
        public var isValidDateTime: Bool = false

        private let cart: CartService

        public init(for placeId: Long, with cart: CartService) {
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

        public enum Labels: String, Localizable {
            public var tableName: String {
                return Localization.tablename
            }

            case title = "Labels.Title"
            case orderOn = "Labels.OrderOn"
            case total = "Labels.Total"
            case selectPaymentCard = "Labels.SelectPaymentCard"
            case comment = "Labels.Comment"
        }
        public enum Buttons: String, Localizable {
            public var tableName: String {
                return Localization.tablename
            }

            case now = "Buttons.Now"
            case today = "Buttons.Today"
            case tomorrow = "Buttons.Tommorow"
            case addNewCard = "Buttons.AddNewCard"
            case editComment = "Buttons.EditComment"
            case addNewOrder = "Buttons.AddNewOrder"
        }
        public enum Toasts: String, Localizable {
            public var tableName: String {
                return Localization.tablename
            }

            case notWorkTime = "Toasts.NotWorkTime"
            case badAddOrder = "Toasts.NotAddOrder"
            case needSelectPaymentCard = "Toasts.NotSelectPaymentCard"
            case problemWithLoad = "Toasts.ProblemWithLoad"
            case problemWithAddCard = "Toasts.ProblemWithAddCard"
        }
    }
}
