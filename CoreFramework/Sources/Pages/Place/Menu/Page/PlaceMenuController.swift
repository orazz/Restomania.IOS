//
//  PlaceMenuController.swift
//  CoreFramework
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit 

public class PlaceMenuController: UIViewController {

    //UI Elements
    @IBOutlet private weak var categoriesView: UICollectionView!
    @IBOutlet private weak var dishesTable: UITableView!
    @IBOutlet private weak var cartAction: PlaceMenuCartAction!
    private var interface: [PlaceMenuElementProtocol] = []
    private var loader: InterfaceLoader!
    private var refreshControl: RefreshControl!
    private var dishesAdapter: DishesPresenter!
    private var categoriesAdapter: CategoriesPresenter!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeColors.statusBarOnNavigation
    }

    // MARK: Services
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)
    private let themeImages = DependencyResolver.get(ThemeImages.self)
    private let menusService = DependencyResolver.get(MenuCacheService.self)
    private let placesService = DependencyResolver.get(PlacesCacheService.self)
    private let apiKeysService = DependencyResolver.get(ApiKeyService.self)
    private var authService = DependencyResolver.get(AuthUIService.self)
    private var cartService: CartService

    // Data
    private let _tag = String.tag(PlaceMenuController.self)
    private let guid = Guid.new
    private var loadQueue: AsyncQueue
    public var placeId: Long
    private var parsedMenu: ParsedMenu? = nil

    private var summaryContainer: PartsLoadTypedContainer<PlaceSummary>!
    private var menuContainer: PartsLoadTypedContainer<MenuSummary>!
    private var loadAdapter: PartsLoader!



    public init(for placeId: Long) {

        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        self.placeId = placeId
        self.cartService = DependencyResolver.get(PlaceCartsFactory.self).get(for: placeId)

        let nibname = String.tag(PlaceMenuController.self)
        super.init(nibName: nibname, bundle: Bundle.coreFramework)

        //Loaders
        self.summaryContainer = PartsLoadTypedContainer<PlaceSummary>(completeLoadHandler: self.completeLoad)
        self.summaryContainer.updateHandler = { update in
            DispatchQueue.main.async {
                self.navigationItem.title = update.Schedule.todayRepresentation
            }
            self.notifyAboutLoadData()
        }
        
        self.menuContainer = PartsLoadTypedContainer<MenuSummary>(completeLoadHandler: self.completeLoad)
        self.menuContainer.updateHandler = { update in
            self.parsedMenu = ParsedMenu(source: update)
            self.notifyAboutLoadData()
        }

        self.loadAdapter = PartsLoader([summaryContainer, menuContainer])
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: View life circle
    public override func loadView() {
        super.loadView()

        view.backgroundColor = themeColors.divider
        dishesTable.backgroundColor = themeColors.divider
        
        loader = InterfaceLoader(for: self.view)
        refreshControl = dishesTable.addRefreshControl(for: self, action: #selector(needReload))
        refreshControl.backgroundColor = themeColors.divider
        refreshControl.tintColor = themeColors.dividerText


        dishesAdapter = DishesPresenter(for: dishesTable, with: self)
        categoriesAdapter = CategoriesPresenter(for: categoriesView, with: self)

        interface = [dishesAdapter, categoriesAdapter, cartAction]
        for var element in interface {
            element.delegate = self
        }

//        let infoIcon = themeImages.iconInfo.tint(color: themeColors.navigationContent)
//        let info = UIImageView(image: infoIcon)
//        let size = 35.0
//        info.frame = CGRect(x: 0, y: 0, width: size, height: size)
//        let button = UIBarButtonItem(customView: info)
//        button.action = #selector(self.goToPlace)
//        navigationItem.rightBarButtonItem = button
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)

        if let summary = takeSummary() {
            navigationItem.title = summary.Schedule.todayRepresentation
        }

        trigger({ $0.viewWillAppear() })
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationItem.title = nil
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        trigger({ $0.viewDidDisappear() })
    }

    private func notifyAboutLoadData() {
        trigger({ $0.update(delegate: self) })
    }
    private func trigger(_ handler: @escaping Action<PlaceMenuElementProtocol>) {
        DispatchQueue.main.async {
            for element in self.interface {
                handler(element)
            }
        }
    }
}

// Load data
extension PlaceMenuController {

    private func loadData() {

        //Place's summary
        if let summary = placesService.cache.find(placeId) {
            summaryContainer.updateAndCheckFresh(summary, cache: placesService.cache)
        }

        //Menu summary
        if let menu = menusService.cache.find(by: placeId, summary: summaryContainer.data) {
            menuContainer.updateAndCheckFresh(menu, cache: menusService.cache)
        }

        if (loadAdapter.noData) {
            loader.show()
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
    }
    private func requestSummary() {
        let request = placesService.find(placeId)
        request.async(loadQueue, completion: summaryContainer.completeLoad)
    }
    private func requestMenu() {
        let request = menusService.find(placeId)
        request.async(loadQueue, completion: menuContainer.completeLoad)
    }
    private func completeLoad() {

        if (self.loadAdapter.isLoad) {

            DispatchQueue.main.async {
                self.loader.hide()
                self.refreshControl.endRefreshing()

                if (self.loadAdapter.problemWithLoad) {
                    Log.error(self._tag, "Problem with load data for page.")
                    self.showToast(Localization.AlertLoadErrorMessage)
                }
            }
        }
    }
}

// PlaceMenuDelegate
extension PlaceMenuController: PlaceMenuDelegate {

    public func takeSummary() -> PlaceSummary? {
        return summaryContainer.data
    }
    public func takeMenu() -> ParsedMenu? {
        return parsedMenu
    }
    public func takeCart() -> CartService {
        return cartService
    }

    public func select(category: Long) {
        Log.debug(_tag, "Select category #\(category)")

        if (category == CategoriesPresenter.commonCategory) {
            dishesAdapter.select(category: nil)
        }
        else {
            dishesAdapter.select(category: category)
        }
    }
    public func select(dish dishId: Long) {

        Log.debug(_tag, "Try add dish #\(dishId)")

        guard let menu = takeMenu(),
                let dish = menu.dishes.find({ $0.id == dishId }) else {
            return
        }

        if (dish.addings.isEmpty && nil == dish.variation) {
            addToCart(dish.id)
            return
        }

        let modal = AddDishToCartModal(for: dish, with: self)
        self.modal(modal, animated: true)
    }
    public func addToCart(_ dishId: Long, with addings: [Long] = [], use variationId: Long? = nil) {

        Log.debug(_tag, "Add dish #\(dishId)")

        cartService.add(dishId: dishId, with: addings, use: variationId)
        showToast(Localization.AlertAddDishToCart, position: .top)
    }
}

extension PlaceMenuController {
    public func goToCart() {

        if (apiKeysService.isAuth) {
            openCartPage()
            return
        }

        showAuth(complete: { success, _ in
            DispatchQueue.main.async {
                if (success) {
                    self.openCartPage()
                } else {
                    self.showToast(Localization.AlertAuthErrorMessage)

                    Log.warning(self._tag, "Not authorize user.")
                }
            }
        })
    }
    private func openCartPage() {

        let vc = PlaceCartController(for: placeId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PlaceMenuController {
    @IBAction private func goPlaceInfo() {
        goToPlace()
    }
    @objc public func goToPlace() {

        //        guard let summary = takeSummary() else {
        //            return
        //        }

        //        let vc = PlaceInfoController(for: summary.id)
        //        self.navigationController?.pushViewController(vc, animated: true)
    }

    public func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PlaceMenuController {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(PlaceMenuController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        //Alerts
        case AlertLoadErrorMessage = "Alerts.LoadError"
        case AlertAuthErrorMessage = "Alerts.AuthError"
        case AlertAddDishToCart = "Alerts.AddDishToCart"

        //Categories
        case AllDishesCategory = "Categories.AllDishes"

        //Buttons
        case ToCart = "Buttons.ToCart"
    }
}
