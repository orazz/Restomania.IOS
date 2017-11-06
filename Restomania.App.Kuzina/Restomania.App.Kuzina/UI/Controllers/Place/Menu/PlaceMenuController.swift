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

public protocol PlaceMenuControllerProtocol {

    func select(category: Long)
    func add(dish: Long)
    func scrollTo(offset: CGFloat)
}
public class PlaceMenuController: UIViewController, PlaceMenuControllerProtocol {

    private static let nibName = "PlaceMenuControllerView"
    public static func create(for placeId: Long) -> PlaceMenuController {

        let vc = PlaceMenuController(nibName: nibName, bundle: Bundle.main)

        vc.placeId = placeId

        return vc
    }

    //UI Elements
    private var _loader: InterfaceLoader!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var placeImage: WrappedImage!
    @IBOutlet weak var dimmer: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeWorkingHours: UILabel!

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var categoriesStack: UICollectionView!
    @IBOutlet weak var dishesTable: UITableView!

    private var _categoriesAdapter: CategoriesCollection!
    private var _dishesAdapter: DishesAdapter!

    //Load data
    private let _tag = String.tag(PlaceMenuController.self)
    private var placeId: Long!
    private var _summary: PlaceSummary?
    private var _summaryCompleteRequest = false
    private var _menu: MenuSummary?
    private var _menuCompleteRequest = false
    private var _cart: Cart!

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUIElements()
        tryHideLoader()

        _loader = InterfaceLoader(for: self.view)

        Log.Info(_tag, "Load place's menu of #\(placeId).")
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()

        _loader.show()

        _categoriesAdapter = CategoriesCollection(collection: categoriesStack, delegate: self)
        _dishesAdapter = DishesAdapter(table: dishesTable, delegate: self)

        _cart = ServicesManager.current.cartsService.cart(placeID: placeId)
        requestSummary()
        requestMenu()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private func setupUIElements() {

        //View
        view.backgroundColor = ThemeSettings.Colors.background
        dimmer.backgroundColor = ThemeSettings.Colors.background

        //Title view
        // - round borders
        titleView.layer.cornerRadius = 5
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = ThemeSettings.Colors.additional.cgColor
        titleView.backgroundColor = ThemeSettings.Colors.additional
        // - shadow
        titleView.layer.shadowColor = ThemeSettings.Colors.additional.cgColor
        titleView.layer.shadowOpacity = 0.13
        titleView.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        titleView.layer.shadowRadius = 5
        titleView.layer.shouldRasterize = true

        //Back button
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.goBack))
        backButton.addGestureRecognizer(tap)
        backButton.isUserInteractionEnabled = true

        //Name
        placeName.font = ThemeSettings.Fonts.bold(size: .title)
        placeName.textColor = ThemeSettings.Colors.main

        //Wokings hours
        placeWorkingHours.font = ThemeSettings.Fonts.default(size: .caption)
        placeWorkingHours.textColor = ThemeSettings.Colors.main

        //Menu

    }
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    //Load summary
    private func requestSummary() {

        let service = ServicesManager.current.placeSummariesService
        _summary = service.findInLocal(placeId)

        //Take local
        if (nil != _summary) {
            applySummary()
            return
        }

        //Take remote
        let task = service.range([ placeId ])
        task.async(.background, completion: { result in

            self._summaryCompleteRequest = true
            if (result.isEmpty) {
                Log.Warning(self._tag, "Problem with load place summary.")
                self.tryHideLoader()
                return
            }

            self._summary = result.first!
            DispatchQueue.main.async {

                self.applySummary()
            }

        })
    }
    private func applySummary() {

        if let summary = _summary {

            //Header
            placeImage.setup(url: summary.Image)
            placeName.text = summary.Name

            var day = summary.Schedule.takeToday()
            if (String.isNullOrEmpty(day)) {
                day = NSLocalizedString("holiday", comment: "Schedule")
            }

            placeWorkingHours.text = day

            //Navbar
            navigationController?.set(title: summary.Name, subtitle: day)
        }

        tryHideLoader()
    }

    //Menu
    private func requestMenu() {

        let service = ServicesManager.current.menuSummariesService
        _menu = service.findInLocal(placeId)

        //Take local
        if (nil != _menu) {
            applyMenu()
            return
        }

        //Take remote
        let task = service.find(placeID: placeId)
        task.async(.background, completion: { result in

            self._menuCompleteRequest = true
            if (nil == result) {
                Log.Warning(self._tag, "Problem with load place's menu.")
                self.tryHideLoader()
                return
            }

            self._menu = result
            DispatchQueue.main.async {

                self.applyMenu()
            }
        })
    }
    private func applyMenu() {

        if let menu = _menu {

            _categoriesAdapter.update(range: menu.categories)
            _dishesAdapter.update(range: menu.dishes, currency: menu.currency)
        }

        tryHideLoader()
    }

    private func tryHideLoader() {

        if (nil != _summary && nil != _menu) {
            _loader.hide()
        }

        if (nil == _summary && _summaryCompleteRequest ||
            nil == _menu && _menuCompleteRequest) {
            Log.Error(_tag, "Problem with load data for page.")

            DispatchQueue.main.async {

                let alert = UIAlertController(title: "Ошибка", message: "У нас возникла проблема с загрузкой данных.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))

                self.navigationController?.popViewController(animated: true)
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: PlaceMenuControllerProtocol
    public func select(category id: Long) {
        Log.Debug(_tag, "Select category #\(id)")

        if (-1 == id) {

            _dishesAdapter.filter(category: nil)
        } else {

            _dishesAdapter.filter(category: id)
        }
    }
    public func add(dish id: Long) {
        Log.Debug(_tag, "Add dish #\(id)")
    }
    public func scrollTo(offset: CGFloat) {

//        Log.Debug(_tag, "scroll table to \(offset)")

//        let bounds = self.view.bounds
//        self.view.frame = CGRect(x: 0, y: -offset, width: bounds.width, height: bounds.height)
    }
    private func moveViewToVerticaly() {

    }

    private class CategoriesCollection: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let _collection: UICollectionView
        private let _delegate: PlaceMenuControllerProtocol
        private var _cateegories: [MenuCategory]

        public init(collection: UICollectionView, delegate: PlaceMenuControllerProtocol) {

            _collection = collection
            _delegate = delegate
            _cateegories = [MenuCategory]()

            super.init()

            let nib = UINib(nibName: PlaceMenuCategoryCell.nibName, bundle: nil)
            _collection.register(nib, forCellWithReuseIdentifier: PlaceMenuCategoryCell.identifier)
            _collection.dataSource = self
            _collection.delegate = self
        }

        // MARK: Interface
        public func update(range: [MenuCategory]) {

            let allCategory = MenuCategory()
            allCategory.name = "Все"
            allCategory.ID = -1

            _cateegories = [allCategory] + range.sorted(by: { $0.orderNumber > $1.orderNumber })
            _collection.reloadData()

            let cell = _collection.cellForItem(at: IndexPath(row: 0, section: 0)) as? PlaceMenuCategoryCell
            cell?.select()
        }

        // MARK: UICollectionViewDataSource
        public func numberOfSections(in collectionView: UICollectionView) -> Int {

            return 1
        }
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return _cateegories.count
        }
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let category = _cateegories[indexPath.row]
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: PlaceMenuCategoryCell.identifier, for: indexPath) as! PlaceMenuCategoryCell
            cell.setup(category: category, handler: { id, card in self.selectCategory(id, sender: card, index: indexPath) })

            return cell
        }

        private func selectCategory(_ id: Long, sender: PlaceMenuCategoryCell, index: IndexPath) {

            for cell in _collection.visibleCells {
                if let cell = cell as? PlaceMenuCategoryCell {

                    cell.unSelect()
                }
            }
            sender.select()
            _collection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)

            _delegate.select(category: id)
        }

        // MARK: UICollectionViewDelegateFlowLayout
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return PlaceMenuCategoryCell.sizeOfCell(category: _cateegories[indexPath.row])
        }
    }
    private class DishesAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let _table: UITableView
        private let _delegate: PlaceMenuControllerProtocol

        private var _dishes: [Dish]
        private var _filtered: [Dish]
        private var _filterCategoryId: Long?

        private var _cells: [Int:PlaceMenuDishCell]
        private var _currency: CurrencyType

        public init(table: UITableView, delegate: PlaceMenuControllerProtocol) {

            _table = table
            _delegate = delegate

            _dishes = [Dish]()
            _filtered = [Dish]()
            _filterCategoryId = nil

            _cells = [Int: PlaceMenuDishCell]()
            _currency = .All

            super.init()

            _table.delegate = self
            _table.dataSource = self
        }

        // MARK: Interface
        public func update(range: [Dish], currency: CurrencyType) {

            _dishes = range.sorted(by: { $0.orderNumber > $1.orderNumber  })
            _currency = currency

            filter(category: _filterCategoryId)
        }
        public func filter(category id: Long?) {

            _filterCategoryId = id
            if let categoryId = _filterCategoryId {

                _filtered = _dishes.where ({ categoryId == $0.categoryId })
            } else {

                _filtered = _dishes
            }

            _table.reloadData()
        }

        // MARK: UITableViewDataSource
        public func numberOfSections(in tableView: UITableView) -> Int {

            return 1
        }
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return _filtered.count
        }

        // MARK: UITableViewDelegate
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return PlaceMenuDishCell.height
        }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if let cell = _cells[indexPath.row] {

                return cell
            }

            let cell = PlaceMenuDishCell.newInstance
            _cells[indexPath.row] = cell
            let dish = _filtered[indexPath.row]

            cell.setup(dish: dish, currency: _currency, handler: { self._delegate.add(dish: $0) })

            return cell
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {

            _delegate.scrollTo(offset: scrollView.contentOffset.y )
        }
    }
}
