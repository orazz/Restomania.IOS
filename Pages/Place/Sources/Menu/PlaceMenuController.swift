//
//  PlaceMenuController.swift
//  Kuzina
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit
import CoreTools
import CoreDomains
import CoreApiServices
import CoreStorageServices
import UITools
import UIElements
import UIServices

public protocol PlaceMenuCellsProtocol: InterfaceTableCellProtocol {

    func viewDidAppear()
    func viewDidDisappear()
    func dataDidLoad(delegate: PlaceMenuDelegate)
}
public protocol PlaceMenuDelegate {

    func takeSummary() -> PlaceSummary?
    func takeMenu() -> MenuSummary?
    func takeCart() -> CartService

    func tryAdd(_ dishId: Long)
    func add(_ dish: Dish, with addings: [Long], use variationId: Long?)
    func select(category: Long)
    func select(dish: Long)
    func scrollTo(offset: CGFloat)

    func goBack()
    func goToCart()
    func goToPlace()
}
public class PlaceMenuController: UIViewController {

    //UI Elements
    private var loader: InterfaceLoader!
    private var refreshControl: RefreshControl!
    @IBOutlet private weak var contentTable: UITableView!
    private var contentRows: [PlaceMenuCellsProtocol] = []
    private var interfaceAdapter: InterfaceTable!
    private var titleBlock: PlaceMenuTitleContainer!
    private var menuBlock: PlaceMenuMenuContainer!
    private var bottomAction: BottomActions!
    private var cartAction: PlaceMenuCartAction!
    @IBOutlet private weak var fadeInPanel: UINavigationBar!
    private var _isInitFadeInPanel: Bool = false
    private var _recheckOffset = CGFloat(100)
    private var _lastOverOffset = CGFloat(0)

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)
    private let themeImages = DependencyResolver.resolve(ThemeImages.self)

    // MARK: Services
    private let menusService = DependencyResolver.resolve(MenuCacheService.self)
    private let placesService = DependencyResolver.resolve(PlacesCacheService.self)
    private var cartService: CartService!
    private var enterService = DependencyResolver.resolve(AuthUIService.self)

    // MARK: Tools
    private var placeId: Long!
    private let _tag = String.tag(PlaceMenuController.self)
    private let guid = Guid.new
    private var loadQueue: AsyncQueue!

    // MARK: Data
    private var summaryContainer: PartsLoadTypedContainer<PlaceSummary>!
    private var menuContainer: PartsLoadTypedContainer<MenuSummary>!
    private var loadAdapter: PartsLoader!

    // MARK: View life circle
    public init(for placeId: Long) {
        super.init(nibName: "PlaceMenuControllerView", bundle: Bundle.main)

        self.placeId = placeId
        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        self.cartService = DependencyResolver.resolve(PlaceCartsFactory.self).get(for: placeId)

        //Loaders
        self.summaryContainer = PartsLoadTypedContainer<PlaceSummary>(completeLoadHandler: self.completeLoad)
        self.summaryContainer.updateHandler = { update in
            DispatchQueue.main.async {
                self.fadeInPanel.topItem?.title = update.Schedule.todayRepresentation
            }
            self.notifyAboutLoadData()
        }

        self.menuContainer = PartsLoadTypedContainer<MenuSummary>(completeLoadHandler: self.completeLoad)
        self.menuContainer.updateHandler = { update in
            DispatchQueue.main.async {
                self.cartAction.update(new: update)
            }
            self.notifyAboutLoadData()
        }

        self.loadAdapter = PartsLoader([summaryContainer, menuContainer])
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()
        loadData()

        Log.info(_tag, "Load place #\(placeId!) menu page.")
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        cartService.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        cartAction.viewDidAppear()
        trigger({ $0.viewDidAppear() })

        _recheckOffset = contentTable.contentSize.height - CGFloat(menuBlock.viewHeight) - CGFloat(64) - CGFloat(20) //64 - MenuBlock, 20 - status bar offset
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        cartService.unsubscribe(guid: guid)
        cartAction.viewDidDisappear()
        trigger({ $0.viewDidDisappear() })

        resetScrolling()
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Actions
    @IBAction private func goPlaceInfo() {
        goToPlace()
    }

    private func trigger(_ handler: Action<PlaceMenuCellsProtocol>) {

        for cell in contentRows {
            handler(cell)
        }
    }
}

// MARK: Load data
extension PlaceMenuController {

    private func loadMarkup() {

        loader = InterfaceLoader(for: self.view)
        refreshControl = contentTable.addRefreshControl(for: self, action: #selector(needReload))

        contentRows = loadRows()
        interfaceAdapter = InterfaceTable(source: contentTable, navigator: self.navigationController!, rows: contentRows)
        interfaceAdapter.delegate = self

        bottomAction = BottomActions(for: self.view)
        cartAction = PlaceMenuCartAction.create(with: self)
        bottomAction.setup(content: cartAction)

        view.backgroundColor = themeColors.contentBackground

        setupFadeOutPanel()
        resetScrolling()

        if (cartService.hasDishes) {
            bottomAction.show()
        }
    }
    private func loadRows() -> [PlaceMenuCellsProtocol] {

        var result = [PlaceMenuCellsProtocol]()

        titleBlock = PlaceMenuTitleContainer.create(with: self)
        result.append(titleBlock)

        menuBlock = PlaceMenuMenuContainer.create(with: self)
        result.append(menuBlock)

        return result
    }

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
                    self.showToast(Keys.AlertLoadErrorMessage)
                }
            }
        }
    }
    private func notifyAboutLoadData() {
        DispatchQueue.main.async {
            self.trigger({ $0.dataDidLoad(delegate: self) })
        }
    }
}

// MARK: PlaceMenuControllerProtocol
extension PlaceMenuController: PlaceMenuDelegate {

    public func takeSummary() -> PlaceSummary? {
        return summaryContainer.data
    }
    public func takeMenu() -> MenuSummary? {
        return menuContainer.data
    }
    public func takeCart() -> CartService {
        return cartService
    }

    public func tryAdd(_ dishId: Long) {

        Log.debug(_tag, "Try add dish #\(dishId)")

        guard let menu = takeMenu(),
                let dish = menu.dishes.find({ $0.id == dishId }) else {
            return
        }

        let addings = menu.addings.filter({ $0.sourceDishId == dishId })
        let variations = menu.variations.filter({ $0.parentDishId == dishId })

        if (addings.isEmpty && variations.isEmpty) {
            add(dish, with: [], use: nil)

            self.presentedViewController?.dismiss(animated: true, completion: nil)
            return
        }

        self.presentedViewController?.dismiss(animated: false, completion: nil)
        let modal = AddDishToCartModal(for: dish, with: addings, and: variations, from: menu, with: self)
        self.modal(modal, animated: true)
    }
    public func add(_ dish: Dish, with addings: [Long], use variationId: Long? = nil) {

        Log.debug(_tag, "Add dish #\(dish.id)")

        cartService.add(dishId: dish.id, with: addings, use: variationId)
        showToast(Keys.AlertAddDishToCart)
    }
    public func select(category: Long) {
        Log.debug(_tag, "Select category #\(category)")
    }
    public func select(dish dishId: Long) {
        Log.debug(_tag, "Select dish #\(dishId)")

        guard let menu = takeMenu(),
            let dish = menu.dishes.find({ $0.id == dishId }) else {
                return
        }

        self.modal(DishModal(for: dish, from: menu, with: self), animated: true)
    }

    @IBAction public func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    public func goToCart() {

        if (enterService.isAuth) {
            openCartPage()
        } else {
            show(enterService, complete: { success in

                if (success) {
                    self.openCartPage()
                } else {
                    Log.warning(self._tag, "Not authorize user.")

                    self.showToast(Keys.AlertAuthErrorMessage)
                }
            })
        }
    }
    private func openCartPage() {

        let vc = PlaceCartController(for: placeId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    public func goToPlace() {

        guard let summary = takeSummary() else {
            return
        }

//        let vc = PlaceInfoController(for: summary.id)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Scrolling
extension PlaceMenuController: UITableViewDelegate {

    //Scroll dishes table
    public func scrollTo(offset: CGFloat) {
        if (offset < -1) {
            menuBlock.disableScroll()

            _lastOverOffset = min(offset, _lastOverOffset)
            contentTable.setContentOffset(CGPoint(x: 0, y: _recheckOffset - count(offset: _lastOverOffset)), animated: true)
            enableScrolling()
        }
    }
    //Scroll content table
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y
        if (offset > _recheckOffset) {
            disableScrolling()

            _lastOverOffset = max(offset - _recheckOffset, _lastOverOffset)
            menuBlock.setScroll(count(offset: _lastOverOffset), animated: true)
            menuBlock.enableScroll()
        }

        updateFadeOutPanel()
    }
    private func enableScrolling() {

        contentTable.bounces = true
        contentTable.alwaysBounceVertical = true
        contentTable.isScrollEnabled = true
    }
    private func disableScrolling() {

        contentTable.setContentOffset(CGPoint(x: 0, y: _recheckOffset), animated: false)

        contentTable.bounces = false
        contentTable.alwaysBounceVertical = false
        contentTable.isScrollEnabled = false
    }
    private func resetScrolling() {

        contentTable.setContentOffset(CGPoint.zero, animated: false)

        enableScrolling()
        menuBlock.disableScroll()
    }
    private func count(offset: CGFloat) -> CGFloat {
        return CGFloat(max(70, min(150, offset * offset)))
    }

    private func setupFadeOutPanel() {

        if (_isInitFadeInPanel) {
            updateFadeOutPanel()
            return
        }
        _isInitFadeInPanel = true

        fadeInPanel.translatesAutoresizingMaskIntoConstraints = false
        fadeInPanel.backgroundColor = themeColors.navigationMain
        fadeInPanel.barTintColor = themeColors.navigationMain
        fadeInPanel.tintColor = themeColors.navigationContent
        fadeInPanel.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: themeColors.navigationContent,
            NSAttributedStringKey.font: themeFonts.default(size: .head)
        ]
        self.view.addSubview(fadeInPanel)

        let top = NSLayoutConstraint(item: fadeInPanel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: fadeInPanel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: fadeInPanel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: fadeInPanel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64)

        for contraint in fadeInPanel.constraints {
            if contraint.firstAttribute == .width {
                NSLayoutConstraint.deactivate([contraint])
                break
            }
        }

        let size = CGFloat(35)
        let leftAction = fadeInPanel.topItem?.leftBarButtonItem?.customView as! UIButton
        let backIcon = themeImages.iconBack.tint(color: themeColors.navigationContent)
        let back = UIImageView(image: backIcon)
        back.frame = CGRect(x: -11, y: leftAction.center.y - size/2, width: size, height: size)
        leftAction.addSubview(back)

        let rightAction = fadeInPanel.topItem?.rightBarButtonItem?.customView as! UIButton
        let infoIcon = themeImages.iconInfo.tint(color: themeColors.navigationContent)
        let info = UIImageView(image: infoIcon)
        info.frame = CGRect(x: 22, y: rightAction.center.y - size/2, width: size, height: size)
        rightAction.addSubview(info)

        NSLayoutConstraint.activate([top, left, right, height])
        updateFadeOutPanel()
    }
    private func updateFadeOutPanel() {

        let offset = contentTable.contentOffset.y
        let startFadeIn = CGFloat(30)
        let endFadeIn = CGFloat(90)
        let fadeInDistance = endFadeIn - startFadeIn

        if (offset < startFadeIn) {
            fadeInPanel.isHidden = true
            return
        } else {
            fadeInPanel.isHidden = false
        }

        if (offset > endFadeIn) {
            fadeInPanel.alpha = 1
        } else {
            fadeInPanel.alpha = (offset - startFadeIn) / fadeInDistance
        }
    }
}

// MARK: Cart
extension PlaceMenuController: CartServiceDelegate {

    public func cart(_ cart: CartService, change dish: AddedOrderDish) {

        DispatchQueue.main.async {
            self.bottomAction.show()
        }
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {

        if cart.hasDishes {
            return
        }
        DispatchQueue.main.async {
            self.bottomAction.hide()
        }
    }
}
extension PlaceMenuController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(PlaceMenuController.self)
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
