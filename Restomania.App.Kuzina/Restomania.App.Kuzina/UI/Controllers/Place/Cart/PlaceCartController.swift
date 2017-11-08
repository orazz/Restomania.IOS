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
    func takeController() -> UIViewController

    func reloadInterface()
    func closePage()
    func tryAddOrder()
}
public class PlaceCartController: UIViewController {

    private static let nibName = "PlaceCartControllerView"
    public static func create(for placeId: Long) -> PlaceCartController {

        let instance = PlaceCartController(nibName: nibName, bundle: Bundle.main)

        instance.placeId = placeId
        instance.cart = ServicesManager.shared.cartsService.get(for: placeId)
        instance.placesService = ServicesManager.shared.placeSummariesService
        instance.menusService = ServicesManager.shared.menuSummariesService
        instance.addPaymentCardsService = AddPaymentCardService()
        instance.keysService = ServicesManager.shared.keysStorage

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
    private var placesService: CachePlaceSummariesService!
    private var menusService: CacheMenuSummariesService!
    private var addPaymentCardsService: AddPaymentCardService!
    private var keysService: IKeysStorage!

    //Data
    private let _tag = String.tag(PlaceCartController.self)
    private var placeId: Long!
    private var contaier: CartContainer!
    private var menu: MenuSummary?
    private var summary: PlaceSummary?
    private var isCompleteLoadSummary: Bool = false
    private var isCompleteLoadMenu: Bool = false

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
//        for row in rows {
//            sectionsAdapter?.add(row)
//        }

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
        back.frame = CGRect(x: -11, y: backButton.center.y - size/2, width: size, height: size)
        backButton.addSubview(back)
    }
}

// MARK: InterfaceTable
extension PlaceCartController {
    private func trigger(_ action: ((PlaceCartContainerCell) -> Void)) {

        for cell in rows {
            action(cell)
        }
    }
    private func loadRows() -> [PlaceCartContainerCell] {

        var result = [PlaceCartContainerCell]()

        result.append(PlaceCartCompleteDateContainer.create(for: self))
        result.append(PlaceCartDivider.create())
        result.append(PlaceCartDishesContainer.create(for: self))
        result.append(PlaceCartDivider.create())
        result.append(PlaceCartDivider.create())
        result.append(PlaceCartDivider.create())
        result.append(PlaceCartCompleteOrderContainer.create(for: self))

        return result
    }
}

//MARk: Load data
extension PlaceCartController {

    private func reloadData() {

        if (keysService.isAuth(for: .User)) {

            isCompleteLoadMenu = false
            isCompleteLoadSummary = false

            requestMenu()
            requestSummary()
        } else {
            closePage()
        }
    }
    private func requestMenu() {

        if let menu = menusService.findInLocal(placeId) {

            self.menu = menu
            self.isCompleteLoadMenu = true
            completeLoad()
            return
        }

        let request = menusService.find(for: placeId)
        request.async(.background, completion: { response in

            if let menu = response {
                self.menu = menu
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

        if let summary = placesService.findInLocal(placeId) {

            self.summary = summary
            self.isCompleteLoadSummary = true
            completeLoad()
            return
        }

        let request = placesService.range([placeId])
        request.async(.background, completion: { response in

            if let summary = response.first {
                self.summary = summary
            } else {
                Log.Error(self._tag, "Problem with load place's summary.")
            }

            DispatchQueue.main.async {

                self.isCompleteLoadSummary = true
                self.completeLoad()
            }
        })
    }
    private func completeLoad() {

        if (!needLoader) {
            loader.hide()
        }

        if ( nil == menu && isCompleteLoadMenu) || (nil == summary && isCompleteLoadSummary) {

            Log.Error(_tag, "Problem with load data for page.")

            self.goBack()

            let alert = UIAlertController(title: "Ошибка", message: "У нас возникла проблема с загрузкой данных.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }

        trigger({ $0.updateData(with: self) })
    }
    private var needLoader: Bool {
        return nil == menu || nil == summary
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
    public func takeController() -> UIViewController {
        return self
    }

    public func reloadInterface() {
        sectionsAdapter?.reload()

        trigger({ $0.updateData(with: self) })
    }
    public func closePage() {
        goBack()
    }
    public func tryAddOrder() {
        Log.Info(_tag, "Try add order.")
    }

    public class CartContainer {

        public let placeId: Long
        public var cardId: Long?
        public var isValidDateTime: Bool = false
        public var date: Date {
            get {
                return cart.date
            }
            set {
                cart.date = newValue
            }
        }
        public var time: Date {
            get {
                return cart.time
            }
            set {
                cart.time = newValue
            }
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

        private let cart: Cart

        public init(for placeId: Long, with cart: Cart) {

            self.placeId = placeId
            self.cart = cart
        }
    }
}
