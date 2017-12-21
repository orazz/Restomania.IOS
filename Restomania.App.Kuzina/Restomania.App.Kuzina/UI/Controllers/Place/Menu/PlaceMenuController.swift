//
//  PlaceMenuController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import AsyncTask
import IOSLibrary

public protocol PlaceMenuCellsProtocol: InterfaceTableCellProtocol {

//    @objc optional func setup(parent: UITableView, controller: PlaceMenuController, delegate: )
    func viewDidAppear()
    func viewDidDisappear()
    func dataDidLoad(delegate: PlaceMenuDelegate)
}
public protocol PlaceMenuDelegate {

    var summary: PlaceSummary? { get }
    var menu: MenuSummary? { get }
    var cart: Cart { get }

    func add(dish: Long)
    func select(category: Long)
    func select(dish: Long)
    func scrollTo(offset: CGFloat)

    func goToCart()
}
public class PlaceMenuController: UIViewController {

    private static let nibName = "PlaceMenuControllerView"
    public static func create(for placeId: Long) -> PlaceMenuController {

        let vc = PlaceMenuController(nibName: nibName, bundle: Bundle.main)

        vc._placeId = placeId
        vc._cart = ToolsServices.shared.cartsService.get(for: placeId)

        return vc
    }

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

    // MARK: Services
    private var menuCache = CacheServices.menu
    private var placesCache = CacheServices.places
    private var _authService: AuthService!
    private var _cart: Cart!

    // MARK: Tools
    private var _placeId: Long!
    private let _tag = String.tag(PlaceMenuController.self)
    private let _guid = Guid.new
    private var loadQueue: AsyncQueue!

    // MARK: Data
    private var summaryContainer: PartsLoadTypedContainer<PlaceSummary>!
    private var menuContainer: PartsLoadTypedContainer<MenuSummary>!
    private var loadAdapter: PartsLoader!

    // MARK: View life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        _authService = AuthService(open: .login, with: self.navigationController!, rights: .user)
        _cart = ToolsServices.shared.cart(for: _placeId)

        summaryContainer = PartsLoadTypedContainer<PlaceSummary>(self)
        summaryContainer.updateHandler = { _ in
            self.completeLoad()
        }

        menuContainer = PartsLoadTypedContainer<MenuSummary>(self)
        menuContainer.updateHandler = { update in
            self.cartAction.update(new: update)
            self.completeLoad()
        }

        loadAdapter = PartsLoader([summaryContainer])

        loadMarkup()
        loadData()

        Log.Info(_tag, "Load place #\(_placeId) menu page.")
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        _cart.subscribe(guid: _guid, handler: self, tag: _tag)

        self.hideNavigationBar()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        cartAction.viewDidAppear()
        trigger({ $0.viewDidAppear() })
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        _cart.unsubscribe(guid: _guid)
        cartAction.viewDidDisappear()
        trigger({ $0.viewDidDisappear() })

        contentTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        enableScrolling()
        menuBlock.disableScroll()
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Actions
    @IBAction private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func goPlaceInfo() {

        if let summary = summaryContainer.data {

            let vc = PlaceInfoController.create(for: summary.ID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func trigger(_ handler: ((PlaceMenuCellsProtocol) -> Void)) {

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

        view.backgroundColor = ThemeSettings.Colors.background

        //Count position of switch scroll
        _recheckOffset = contentTable.contentSize.height - CGFloat(menuBlock.viewHeight) - CGFloat(64) - CGFloat(20) //64 - MenuBlock, 20 - status bar offset

        menuBlock.disableScroll()
        setupFadeOutPanel()

        if (_cart.hasDishes) {
            bottomAction.show()
        }
    }
    private func loadRows() -> [PlaceMenuCellsProtocol] {

        var result = [PlaceMenuCellsProtocol]()

        titleBlock = PlaceMenuTitleContainer.create(with: self.navigationController!)
        result.append(titleBlock)

        menuBlock = PlaceMenuMenuContainer.create(with: self)
        result.append(menuBlock)

        return result
    }

    private func loadData() {

        if let summary = placesCache.cache.find(_placeId) {
            summaryContainer.update(summary)
        }

        if let summary = summaryContainer.data,
           let menu = menuCache.cache.find(summary.menuId) {
            menuContainer.update(menu)
        } else if let menu = menuCache.cache.find({ $0.placeID == self._placeId }) {
            menuContainer.update(menu)
        }

        if (!loadAdapter.hasData) {
            loader.show()
        }

        requestData()
    }
    @objc private func needReload() {
        requestData()
    }
    private func requestData() {

        summaryContainer.startRequest()
        menuContainer.startRequest()

        requestSummary()
        requestMenu()
    }

    //MARK Place summary
    private func requestSummary() {

        let request = placesCache.find(_placeId)
        request.async(loadQueue, completion: summaryContainer.completeLoad)
    }

    // MARK: Menu
    private func requestMenu() {

        let request = menuCache.find(for: _placeId)
        request.async(loadQueue, completion: menuContainer.completeLoad)
    }

    private func completeLoad() {
        DispatchQueue.main.async {

            if (self.loadAdapter.isFail) {
                Log.Error(self._tag, "Problem with load data for page.")

                let alert = ProblemAlerts.toastAlert(title: Keys.AlertLoadErrorTitle,
                                                    message: Keys.AlertLoadErrorMessage)

                self.navigationController?.popViewController(animated: true)
                self.navigationController?.present(alert, animated: true, completion: nil)
            }

            if (self.loadAdapter.isLoad) {
                self.loader.hide()
                self.refreshControl.endRefreshing()
            }

            self.trigger({ $0.dataDidLoad(delegate: self) })
        }
    }
}

// MARK: PlaceMenuControllerProtocol
extension PlaceMenuController: PlaceMenuDelegate {

    public var summary: PlaceSummary? {
        return summaryContainer.data
    }
    public var menu: MenuSummary? {
        return menuContainer.data
    }
    public var cart: Cart {
        return _cart
    }

    public func add(dish: Long) {
        Log.Debug(_tag, "Add dish #\(dish)")

        _cart.add(dishId: dish)
    }
    public func select(category: Long) {
        Log.Debug(_tag, "Select category #\(category)")

    }
    public func select(dish: Long) {
        Log.Debug(_tag, "Select dish #\(dish)")
    }

    public func goToCart() {

        if (_authService.isAuth(for: .user)) {
            openCartPage()
        } else {
             _authService.show(complete: { success in

                if (success) {
                    self.openCartPage()
                } else {
                    Log.Warning(self._tag, "Not authorize user.")

                    let alert = ProblemAlerts.toastAlert(title: Keys.AlertAuthErrorTitle,
                                                        message: Keys.AlertAuthErrorMessage)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    private func openCartPage() {

        let vc = PlaceCartController.create(for: _placeId)
        self.navigationController?.pushViewController(vc, animated: true)
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
        fadeInPanel.backgroundColor = ThemeSettings.Colors.main
        fadeInPanel.barTintColor = ThemeSettings.Colors.main
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
        let back = UIImageView(image: ThemeSettings.Images.navigationBackward)
        back.frame = CGRect(x: -11, y: leftAction.center.y - size/2, width: size, height: size)
        leftAction.addSubview(back)

        let rightAction = fadeInPanel.topItem?.rightBarButtonItem?.customView as! UIButton
        let info = UIImageView(image: ThemeSettings.Images.iconInfo)
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
extension PlaceMenuController: CartUpdateProtocol {

    public func cart(_ cart: Cart, changedDish: Long, newCount: Int) {
        DispatchQueue.main.async {
            self.bottomAction.show()
        }
    }
    public func cart(_ cart: Cart, removedDish: Long) {
        DispatchQueue.main.async {
            if (cart.isEmpty) {
                self.bottomAction.hide()
            }
        }
    }
}
extension PlaceMenuController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(PlaceMenuController.self)
        }

        case AlertLoadErrorTitle = "Alerts.LoadError.Title"
        case AlertLoadErrorMessage = "Alerts.LoadError.Message"

        case AlertAuthErrorTitle = "Alerts.AuthError.Title"
        case AlertAuthErrorMessage = "Alerts.AuthError.Message"
    }
}
