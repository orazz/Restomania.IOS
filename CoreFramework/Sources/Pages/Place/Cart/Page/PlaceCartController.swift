//
//  PlaceCartController.swift
//  CoreFramework
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public protocol PlaceCartDelegate {

    func takeCartContainer() -> PlaceCartController.CartContainer
    func takeSummary() -> PlaceSummary?
    func takeMenu() -> MenuSummary?
    func takeCart() -> CartService
    func takeCards() -> [PaymentCard]?
    func takeController() -> UIViewController

    func resize()
    func closePage()
    func addPaymentCard()
    func tryAddOrder()
}
public class PlaceCartController: UIViewController {

    //UI elements
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var dateTimePicker: PlaceCartTimePicker!
    @IBOutlet private weak var dateTimeDivider: PlaceCartDivider!
    @IBOutlet private weak var dishesDivider: PlaceCartDivider!
    @IBOutlet private weak var cardsDivider: PlaceCartDivider!
    @IBOutlet private weak var additionalElement: PlaceCartAdditionalContainer!
    @IBOutlet private weak var additionalDivider: PlaceCartDivider!
    @IBOutlet private weak var completeOrderAction: PlaceCartCompleteOrderAction!
    private var refreshControl: RefreshControl!
    private var interfaceLoader: InterfaceLoader!
    private var interfaceElements: [PlaceCartElement & UIView] = []

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)
    private let themeImages = DependencyResolver.get(ThemeImages.self)

    // MARK: Services
    private var addPaymentCardsService = DependencyResolver.get(AddCardUIService.self)
    private var keysService = DependencyResolver.get(ApiKeyService.self)
    private var ordersService = DependencyResolver.get(OrdersCacheService.self)
    private var placesService = DependencyResolver.get(PlacesCacheService.self)
    private var menusService = DependencyResolver.get(MenuCacheService.self)
    private var cardsService = DependencyResolver.get(CardsCacheService.self)

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

        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        self.placeId = placeId
        self.cart = DependencyResolver.get(PlaceCartsFactory.self).get(for: placeId)
        self.cartContaier = CartContainer(for: placeId, with: cart)

        super.init(nibName: String.tag(PlaceCartController.self), bundle: Bundle.coreFramework)

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
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: View life circle
extension PlaceCartController {
    public override func loadView() {
        super.loadView()

        loadMarkup()
    }
    private func loadMarkup() {

        view.backgroundColor = themeColors.divider
        scrollView.backgroundColor = themeColors.divider
        contentView.backgroundColor = themeColors.divider

        scrollView.alwaysBounceVertical = true

        interfaceLoader = InterfaceLoader(for: self.view)
        interfaceElements = loadElements()

        refreshControl = scrollView.addRefreshControl(for: self, action: #selector(needReload))
        refreshControl.removeFromSuperview()
        refreshControl?.backgroundColor = themeColors.divider
        refreshControl?.tintColor = themeColors.dividerText
        scrollView.insertSubview(refreshControl, at: 0)

        navigationItem.title = Localization.Labels.title.localized

        resize()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setStatusBarStyle(from: themeColors.statusBarOnNavigation)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        trigger({ $0.cartWillAppear() })
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        trigger({ $0.cartWillDisappear() })
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: InterfaceTable
extension PlaceCartController {
    private func trigger(_ action: @escaping ((PlaceCartElement) -> Void)) {

        DispatchQueue.main.async {
            for cell in self.interfaceElements {
                action(cell)
            }
        }
    }
    private func loadElements() -> [PlaceCartElement & UIView] {

        var result = [PlaceCartElement & UIView]()

        result.append(dateTimePicker)
        result.append(dateTimeDivider)

//        result.append(dishesDivider)
        result.append(dishesDivider)

//        result.append(dishesDivider)
        result.append(cardsDivider)

        result.append(additionalElement)
        result.append(additionalDivider)

        result.append(completeOrderAction)

        for element in result {
            element.update(with: self)
        }

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
                self.refreshControl?.endRefreshing()

                if (self.loadAdapter.problemWithLoad) {
                    self.showToast(Localization.Toasts.problemWithLoad)
                    Log.error(self._tag, "Problem with load data for page.")
                }
            }
        }
    }
    private func notifyAboutUpdateData() {
        DispatchQueue.main.async {
            self.trigger({ $0.update(with: self) })
            self.resize()
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

    public func resize() {

        var commonHeight: CGFloat = 0.0
        for element in interfaceElements {
            commonHeight = commonHeight + element.height()
        }

        commonHeight = max(commonHeight, view.frame.height)

        scrollView.contentSize = CGSize(width: view.frame.width, height: commonHeight)
//        contentView.setContraint(height: commonHeight)
        UIView.animate(withDuration: 0.4) {
            self.scrollView.layoutIfNeeded()
            self.contentView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.3) {
            for element in self.interfaceElements {
                element.layoutIfNeeded()
            }
        }
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

                self.trigger({ $0.update(with: self) })
                self.resize()
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
            public var bundle: Bundle {
                return Bundle.coreFramework
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
            public var bundle: Bundle {
                return Bundle.coreFramework
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
            public var bundle: Bundle {
                return Bundle.coreFramework
            }

            case notWorkTime = "Toasts.NotWorkTime"
            case badAddOrder = "Toasts.NotAddOrder"
            case needSelectPaymentCard = "Toasts.NotSelectPaymentCard"
            case problemWithLoad = "Toasts.ProblemWithLoad"
            case problemWithAddCard = "Toasts.ProblemWithAddCard"
        }
    }
}
