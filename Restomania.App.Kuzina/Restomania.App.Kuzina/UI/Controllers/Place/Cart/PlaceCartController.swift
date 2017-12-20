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

    func takeContainer() -> PlaceCartController.CartContainer
    func takeMenu() -> MenuSummary?
    func takeSummary() -> PlaceSummary?
    func takeCart() -> Cart
    func takeCards() -> [PaymentCard]?
    func takeController() -> UIViewController

    func reloadInterface()
    func closePage()
    func addPaymentCard()
    func tryAddOrder()
}
public class PlaceCartController: UIViewController {

    private static let nibName = "PlaceCartControllerView"
    public static func create(for placeId: Long) -> PlaceCartController {

        let instance = PlaceCartController(nibName: nibName, bundle: Bundle.main)

        instance.placeId = placeId
        instance.cart = ToolsServices.shared.cart(for: placeId)
        instance.placesService = CacheServices.places
        instance.menusService = CacheServices.menu
        instance.cardsService = CacheServices.cards
        instance.addPaymentCardsService = AddCardUIService()
        instance.keysService = ToolsServices.shared.keys
        instance.ordersApiService = ApiServices.Users.orders

        return instance
    }

    //UI elements
    @IBOutlet private weak var navigationBarStubDimmer: UIView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var backNavigationItem: UIBarButtonItem!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet private weak var contentTable: UITableView!
    private var loader: InterfaceLoader!

    //Services
    private var sectionsAdapter: InterfaceTable?
    private var rows: [PlaceCartContainerCell] = []
    private var cart: Cart!
    private var placesService: PlacesCacheService!
    private var menusService: MenuCacheService!
    private var cardsService: CardsCacheService!
    private var addPaymentCardsService: AddCardUIService!
    private var keysService: KeysStorage!
    private var ordersApiService: UserOrdersApiService!

    //Data
    private let _tag = String.tag(PlaceCartController.self)
    private var placeId: Long!
    private var contaier: CartContainer!
    private var menu: MenuSummary?
    private var summary: PlaceSummary?
    private var cards: [PaymentCard]?
    private var isCompleteLoadSummary: Bool = false
    private var isCompleteLoadMenu: Bool = false
    private var isCompleteLoadCards: Bool = false

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

        loader = InterfaceLoader(for: self.view)
        contaier = CartContainer(for: placeId, with: cart)

        rows = loadRows()
        sectionsAdapter = InterfaceTable(source: contentTable, navigator: self.navigationController!, rows: rows.map { $0 as InterfaceTableCellProtocol })

        reloadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (needLoader) {
            loader.show()
        }

        setupStyles()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        trigger({ $0.viewDidAppear() })
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        trigger({ $0.viewDidDisappear() })
    }
    private func setupStyles() {

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
            for cell in self.rows {
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

    private func reloadData() {

        if (keysService.isAuth(for: .user)) {

            isCompleteLoadMenu = false
            isCompleteLoadSummary = false
            isCompleteLoadCards = false

            requestMenu()
            requestSummary()
            requestCards()
        } else {
            closePage()
        }
    }
    private func requestMenu() {

        if let menu = menusService.cache.find{ $0.placeID == placeId } {

            self.menu = menu
            self.isCompleteLoadMenu = true
            completeLoad()
            return
        }

        let request = menusService.find(for: placeId)
        request.async(.background, completion: { response in

            if (response.isSuccess) {
                self.menu = response.data!
            } else {
                Log.Error(self._tag, "Problem with load place's menu summary.")
            }

            DispatchQueue.main.async {

                self.isCompleteLoadMenu = true
                self.completeLoad()
            }
        })
    }
    private func requestSummary() {

        if let summary = placesService.cache.find(placeId) {

            self.summary = summary
            self.isCompleteLoadSummary = true
            completeLoad()
            return
        }

        let request = placesService.find(placeId)
        request.async(.background, completion: { response in

            if (response.isSuccess) {
                self.summary = response.data!
            }
            else {
                Log.Error(self._tag, "Problem with load place's summary.")
            }

            DispatchQueue.main.async {

                self.isCompleteLoadSummary = true
                self.completeLoad()
            }
        })
    }
    private func requestCards() {

        let request = card.all()
        request.async(.background, completion: { result in

            if let cards = result {
                self.cards = cards
            } else {
                Log.Error(self._tag, "Problem with load user's payment cards.")
            }

            DispatchQueue.main.async {

                self.isCompleteLoadCards = true
                self.completeLoad()
            }
        })
    }
    private func completeLoad() {

        if (!needLoader) {
            loader.hide()
        }

        if ( nil == menu && isCompleteLoadMenu) ||
            (nil == summary && isCompleteLoadSummary) ||
            (nil == cards && isCompleteLoadCards) {

            Log.Error(_tag, "Problem with load data for page.")

            self.goBack()

            let alert = UIAlertController(title: "Ошибка", message: "У нас возникла проблема с загрузкой данных.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }

        trigger({ $0.updateData(with: self) })
        reloadInterface()
    }
    private var needLoader: Bool {
        return nil == menu || nil == summary || nil == cards
    }
}

// MARK: PlaceCartDelegate
extension PlaceCartController: PlaceCartDelegate {

    public func takeContainer() -> PlaceCartController.CartContainer {
        return contaier
    }
    public func takeMenu() -> MenuSummary? {
        return menu
    }
    public func takeSummary() -> PlaceSummary? {
        return summary
    }
    public func takeCart() -> Cart {
        return cart
    }
    public func takeCards() -> [PaymentCard]? {
        return cards
    }
    public func takeController() -> UIViewController {
        return self
    }

    public func reloadInterface() {
        sectionsAdapter?.reload()
    }
    public func closePage() {
        goBack()
    }
    public func addPaymentCard() {

        guard let menu = menu else {
            return
        }

        addPaymentCardsService.addCard(for: menu.currency, on: self, complete: { success, result in

            DispatchQueue.main.async {

                if (!success) {
                    let alert = UIAlertController(title: "Ошибка", message: "Проблемы с добавление платежной карты", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }

                self.loader.show()
                let request = self.cardsService.find(result)
                request.async(.background, completion: { result in

                        if let card = result {
                            if nil == self.cards {
                                self.cards = []
                            }

                            self.cards?.append(card)
                            self.contaier.cardId = card.ID

                            self.trigger({ $0.updateData(with: self) })
                        }

                    DispatchQueue.main.async {
                        self.loader.hide()
                    }
                })

            }

        })
    }
    public func tryAddOrder() {
        Log.Info(_tag, "Try add order.")

        loader.show()

        let builded = contaier.prepareOrder()
        let request = ordersApiService.add(order: builded)
        request.async(.background, completion: { response in

            DispatchQueue.main.async {

                if (response.isFail) {
                    let alert = UIAlertController(title: "Ошибка", message: "Проблемы с добавление заказа", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    self.loader.hide()
                } else {
                    let order = response.data!
                    let vc = PlaceCompleteOrderController.create(for: order)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }

    public class CartContainer {

        public let placeId: Long
        public var cardId: Long?
        public var isValidDateTime: Bool = false

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

        private let cart: Cart

        public init(for placeId: Long, with cart: Cart) {

            self.placeId = placeId
            self.cart = cart
        }
    }
}
