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

public protocol PlaceCartContainerCell {

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
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var backNavigationItem: UIBarButtonItem!
    @IBOutlet private weak var contentView: UITableView!
    private var loader: InterfaceLoader!

    //Services
    private var sectionsAdapter: InterfaceTable!
    private var rows: [PlaceCartContainerCell] = []
    private var cart: Cart!
    private var placesService: CachePlaceSummariesService!
    private var menusService: CacheMenuSummariesService!
    private var addPaymentCardsService: AddPaymentCardService!
    private var keysService: IKeysStorage!
    private var authService: AuthService!

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

        authService = AuthService(open: .login, with: self.navigationController!, rights: .User)

        loader = InterfaceLoader(for: self.view)
        contaier = CartContainer(for: placeId)
        rows = loadRows()

        tryLoadData()
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

        navigationBar.barTintColor = ThemeSettings.Colors.additional

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

//        result.append(PlaceCartContainerCell())

        return result
    }
}

//MARk: Load data
extension PlaceCartController {

    private func tryLoadData() {

        if (keysService.isAuth(for: .User)) {
            reloadData()
        }
        else {
            authService.show(complete: { success in

                if (success) {
                    self.reloadData()
                }
                else {

                    Log.Error(self._tag, "Problem with load data for page.")

                    let alert = UIAlertController(title: "Авторизация", message: "Для заказа через приложение необходима авторизация.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))

                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    private func reloadData() {
        requestMenu()
        requestPlace()
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
    private func requestPlace() {

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

            self.navigationController?.popViewController(animated: true)

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

    public class CartContainer {

        public let placeId: Long
        public var cardId: Long?
        public var completeDate: Date = Date()
        public var comment: String = String.empty
        public var takeaway: Bool = false

        public init(for placeId: Long) {

            self.placeId = placeId
        }
    }

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

    public func tryAddOrder() {
        Log.Info(_tag, "Try add order.")
    }
}
