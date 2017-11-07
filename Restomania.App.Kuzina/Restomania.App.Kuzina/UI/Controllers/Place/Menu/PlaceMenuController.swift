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

    //Load data
    private let _tag = String.tag(PlaceMenuController.self)
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

        _recheckOffset = contentTable.contentSize.height - CGFloat(_menuBlock.viewHeight) - CGFloat(64)

        trigger({ $0.viewDidDisappear() })
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        trigger({ $0.viewDidDisappear() })
    }

    private func setupMarkup() {

        self.hideNavigationBar()

        view.backgroundColor = ThemeSettings.Colors.background

        _menuBlock.disableScroll()
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
                completeLoad()
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
                self.completeLoad()
            }
        })
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
    public func scrollTo(offset: CGFloat) {
        if (offset <= 0) {

            _lastOverOffset = min(offset, _lastOverOffset)
            contentTable.bounces = true
            contentTable.alwaysBounceVertical = true
            contentTable.isScrollEnabled = true
//            contentTable.setContentOffset(CGPoint(x: 0, y: _recheckOffset), animated: false)
            contentTable.setContentOffset(CGPoint(x: 0, y: _recheckOffset - count(offset: _lastOverOffset)), animated: true)

            _menuBlock.disableScroll()
        }
    }
}
extension PlaceMenuController: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y
        if (offset > _recheckOffset) {

            _lastOverOffset = max(offset - _recheckOffset, _lastOverOffset)
            contentTable.setContentOffset(CGPoint(x: 0, y: _recheckOffset), animated: false)
            contentTable.bounces = false
            contentTable.alwaysBounceVertical = false
            contentTable.isScrollEnabled = false

            _menuBlock.enableScroll()
//            _menuBlock.setScroll(0)
            _menuBlock.setScroll(count(offset: _lastOverOffset), animated: true)
        }
    }
    private func count(offset: CGFloat) -> CGFloat {
        return CGFloat(max(70, min(150, offset * offset)))
    }
}
