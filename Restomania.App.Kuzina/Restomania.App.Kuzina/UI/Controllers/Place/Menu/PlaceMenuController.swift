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
}
public class PlaceMenuController: UIViewController {

    private static let nibName = "PlaceMenuControllerView"
    public static func create(for placeId: Long) -> PlaceMenuController {

        let vc = PlaceMenuController(nibName: nibName, bundle: Bundle.main)

        vc._placeId = placeId
        vc._menuService = ServicesManager.current.menuSummariesService
        vc._placesService = ServicesManager.current.placeSummariesService
        vc._cart = ServicesManager.current.cartsService.cart(placeID: placeId)

        return vc
    }

    //UI Elements
    private var _loader: InterfaceLoader!
    private var _refreshControl: UIRefreshControl!
    @IBOutlet private weak var contentTable: UITableView!
    private var _contentRows: [PlaceMenuCellsProtocol] = []
    private var _interfaceAdapter: InterfaceTable!
    private var _titleBlock: PlaceMenuTitleContainer!
    private var _menuBlock: PlaceMenuMenuContainer!
    @IBOutlet private weak var fadeInPanel: UINavigationBar!
    @IBAction private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func goPlaceInfo() {

        guard let summary = _summary else {
            return
        }

        let vc = PlaceInfoController.create(for: summary.ID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private var _bottomAction: BottomActions!
    private var _cartAction: PlaceMenuCartAction!

    //Load data
    private let _tag = String.tag(PlaceMenuController.self)
    private let _guid = Guid.new
    private var _placeId: Long!
    private var _summary: PlaceSummary?
    private var _menu: MenuSummary?
    private var _summaryCompleteRequest = false
    private var _menuCompleteRequest = false
    private var _cart: Cart!
    private var _menuService: CacheMenuSummariesService!
    private var _placesService: CachePlaceSummariesService!
    private var _recheckOffset = CGFloat(100)
    private var _lastOverOffset = CGFloat(0)

    // MARK: View life circle
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)

        _refreshControl = UIRefreshControl()
        _refreshControl.backgroundColor = ThemeSettings.Colors.background
        _refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        _refreshControl.addTarget(self, action: #selector(needReload), for: .valueChanged)
        contentTable.addSubview(_refreshControl)

        _interfaceAdapter = InterfaceTable(source: contentTable, navigator: self.navigationController!)
        _interfaceAdapter.delegate = self
        for cell in loadRows() {
            _contentRows.append(cell)
            _interfaceAdapter.add(cell)
        }

        _cart = ServicesManager.current.cartsService.cart(placeID: _placeId)

        _bottomAction = BottomActions(for: self.view)
        _cartAction = PlaceMenuCartAction.create(for: _cart, with: self.navigationController!)
        _bottomAction.setup(content: _cartAction)

        reloadData()

        Log.Info(_tag, "Load place's menu of #\(_placeId).")
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (isNeedShowLoader) {
            _loader.show()
        }

        setupMarkup()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _recheckOffset = contentTable.contentSize.height - CGFloat(_menuBlock.viewHeight) - CGFloat(64) - CGFloat(20) //64 - MenuBlock, 20 - status bar offset

        _cart.subscribe(guid: _guid, handler: self, tag: _tag)
        trigger({ $0.viewDidDisappear() })

        _cartAction.viewDidAppear()
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        _cart.unsubscribe(guid: _guid)
        trigger({ $0.viewDidDisappear() })

        _cartAction.viewDidDisappear()
    }

    private func setupMarkup() {

        self.hideNavigationBar()

        view.backgroundColor = ThemeSettings.Colors.background

        _menuBlock.disableScroll()
        setupFadeOutPanel()

        if (_cart.hasDishes) {
            _bottomAction.show()
        }
    }

    private func loadRows() -> [PlaceMenuCellsProtocol] {

        var result = [PlaceMenuCellsProtocol]()

        _titleBlock = PlaceMenuTitleContainer.create(with: self.navigationController!)
        result.append(_titleBlock)

        _menuBlock = PlaceMenuMenuContainer.create(with: self)
        result.append(_menuBlock)

        return result
    }
    private func trigger(_ handler: ((PlaceMenuCellsProtocol) -> Void)) {

        for cell in _contentRows {
            handler(cell)
        }
    }
}

// MARK: Load data
extension PlaceMenuController {

    @objc private func needReload() {

        reloadData(ignoreCache: true)
    }
    private func reloadData(ignoreCache: Bool = false) {

        _menuCompleteRequest = false
        _summaryCompleteRequest = false

        requestSummary(ignoreCache)
        requestMenu(ignoreCache)
    }
    private func requestMenu(_ ignoreCache: Bool) {

        //Take local
        if (!ignoreCache) {
            if let menu = _menuService.findInLocal(_placeId) {

                _menu = menu
                applyMenu()
                return
            }
        }

        //Take remote
        let task = _menuService.find(placeID: _placeId, ignoreCache: ignoreCache)
        task.async(.background, completion: { result in

            if (nil == result) {
                Log.Warning(self._tag, "Problem with load place's menu.")
            } else {
                self._menu = result
            }

            DispatchQueue.main.async {

                self._menuCompleteRequest = true
                self.applyMenu()
            }
        })
    }
    private func applyMenu() {

        if let menu = _menu {
            _cartAction.update(currency: menu.currency)
        }

        completeLoad()
    }
    private func requestSummary(_ ignoreCache: Bool) {

        //Take local
        if (!ignoreCache) {
            if let summary = _placesService.findInLocal(_placeId) {

                _summary = summary
                completeLoad()
                return
            }
        }

        //Take remote
        let task = _placesService.range([ _placeId ], ignoreCache: ignoreCache)
        task.async(.background, completion: { result in

            if (result.isEmpty) {
                Log.Warning(self._tag, "Problem with load place summary.")
            } else {
                self._summary = result.first!
            }

            DispatchQueue.main.async {

                self._summaryCompleteRequest = true
                self.completeLoad()
            }
        })
    }
    private func completeLoad() {

        if (!isNeedShowLoader) {
            _loader.hide()
        }

        if (nil == _summary && _summaryCompleteRequest ||
            nil == _menu && _menuCompleteRequest) {
            Log.Error(_tag, "Problem with load data for page.")

            let alert = UIAlertController(title: "Ошибка", message: "У нас возникла проблема с загрузкой данных.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))

            self.navigationController?.popViewController(animated: true)
            self.navigationController?.present(alert, animated: true, completion: nil)
        }

        if (_refreshControl.isRefreshing && isCompleteLoad) {
            _refreshControl.endRefreshing()
        }

        trigger({ $0.dataDidLoad(delegate: self) })
    }
    private var isNeedShowLoader: Bool {
        return nil == _summary || nil == _menu
    }
    private var isCompleteLoad: Bool {
        return _menuCompleteRequest && _summaryCompleteRequest
    }
}

// MARK: PlaceMenuControllerProtocol
extension PlaceMenuController: PlaceMenuDelegate {

    public var summary: PlaceSummary? {
        return _summary
    }
    public var menu: MenuSummary? {
        return _menu
    }
    public var cart: Cart {
        return _cart
    }

    public func add(dish: Long) {
        Log.Debug(_tag, "Add dish #\(dish)")

        _cart.add(dish: _menu!.dishes.find({ dish == $0.ID })!)
    }
    public func select(category: Long) {
        Log.Debug(_tag, "Select category #\(category)")

    }
    public func select(dish: Long) {
        Log.Debug(_tag, "Select dish #\(dish)")
    }
}

// MARK: Scrolling
extension PlaceMenuController: UITableViewDelegate {

    //Scroll dishes table
    public func scrollTo(offset: CGFloat) {
        if (offset < -1) {
            _menuBlock.disableScroll()

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
            _menuBlock.setScroll(count(offset: _lastOverOffset), animated: true)
            _menuBlock.enableScroll()
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

    public func cart(_ cart: Cart, changedDish: Dish, newCount: Int) {

        DispatchQueue.main.async {
            self._bottomAction.show()
        }
    }

    public func cart(_ cart: Cart, removedDish: Long) {

        DispatchQueue.main.async {
            if (cart.isEmpty) {
                self._bottomAction.hide()
            }
        }
    }
}
