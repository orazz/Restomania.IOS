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

        return vc
    }

    //UI Elements
    private var _loader: InterfaceLoader!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var placeImage: WrappedImage!
    @IBOutlet weak var dimmer: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeWorkingHours: UILabel!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var categoriesStack: UICollectionView!
    @IBOutlet weak var dishesTable: UITableView!

    private var _categoriesAdapter: CategoriesCollection!
    private var _dishesAdapter: DishesAdapter!

    //Actions
    @IBAction private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction private func goPlaceInfo() {

        let vc = PlaceInfoController.create(for: _placeId)

        navigationController?.pushViewController(vc, animated: true)
    }

    //Load data
    private let _tag = String.tag(PlaceMenuController.self)
    private var _placeId: Long!
    private var _summary: PlaceSummary?
    private var _summaryCompleteRequest = false
    private var _menu: MenuSummary?
    private var _menuCompleteRequest = false
    private var _cart: Cart!

    // MARK: View life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        completeLoad()

        _loader = InterfaceLoader(for: self.view)

        Log.Info(_tag, "Load place's menu of #\(_placeId).")
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()

        _loader.show()
        setupUIElements()

        _categoriesAdapter = CategoriesCollection(collection: categoriesStack, delegate: self)
        _dishesAdapter = DishesAdapter(table: dishesTable, delegate: self)

        _cart = ServicesManager.current.cartsService.cart(placeID: _placeId)
        requestSummary()
        requestMenu()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        _dishesAdapter.clear()
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

        //Name
        placeName.font = ThemeSettings.Fonts.bold(size: .subhead)
        placeName.textColor = ThemeSettings.Colors.main

        //Wokings hours
        placeWorkingHours.font = ThemeSettings.Fonts.default(size: .caption)
        placeWorkingHours.textColor = ThemeSettings.Colors.main
    }

    private func completeLoad() {

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
}

// MARK: Load menu
extension PlaceMenuController {
    private func requestMenu() {

        let service = ServicesManager.current.menuSummariesService
        _menu = service.findInLocal(_placeId)

        //Take local
        if (nil != _menu) {
            applyMenu()
            return
        }

        //Take remote
        let task = service.find(placeID: _placeId)
        task.async(.background, completion: { result in

            self._menuCompleteRequest = true
            if (nil == result) {
                Log.Warning(self._tag, "Problem with load place's menu.")
                self.completeLoad()
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

            let allCategory = MenuCategory()
            allCategory.name = "Всё"
            allCategory.ID = -1
            allCategory.orderNumber = -1

            _categoriesAdapter.update(range: [allCategory] + menu.categories)
            _dishesAdapter.update(range: menu.dishes, currency: menu.currency)
        }

        completeLoad()
    }
}

// MARK: Load summary
extension PlaceMenuController {
    private func requestSummary() {

        let service = ServicesManager.current.placeSummariesService
        _summary = service.findInLocal(_placeId)

        //Take local
        if (nil != _summary) {
            applySummary()
            return
        }

        //Take remote
        let task = service.range([ _placeId ])
        task.async(.background, completion: { result in

            self._summaryCompleteRequest = true
            if (result.isEmpty) {
                Log.Warning(self._tag, "Problem with load place summary.")
                self.completeLoad()
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

        completeLoad()
    }
}

// MARK: PlaceMenuControllerProtocol
extension PlaceMenuController: PlaceMenuControllerProtocol {

    public func add(dish: Long) {
        Log.Debug(_tag, "Add dish #\(dish)")

        _cart.add(dish: _menu!.dishes.find({ dish == $0.ID })!)
    }
    public func select(category: Long) {
        Log.Debug(_tag, "Select category #\(category)")

        if (-1 == category) {
            _dishesAdapter.filter(by: nil)
        } else {

            _dishesAdapter.filter(by: category)
        }

        if (!dishesTable.visibleCells.isEmpty) {
            dishesTable.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    public func select(dish: Long) {
        Log.Debug(_tag, "Select dish #\(dish)")
    }
    public func scrollTo(offset: CGFloat) {

//        Log.Debug(_tag, "scroll table to \(offset)")

//        let bounds = self.view.bounds
//        self.view.frame = CGRect(x: 0, y: -offset, width: bounds.width, height: bounds.height)
    }
//    private func moveViewToVerticaly() {
//
//    }
}

// MARK: Categories
extension PlaceMenuController {
    private class CategoriesCollection: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let _collection: UICollectionView
        private let _delegate: PlaceMenuControllerProtocol
        private var _categories: [MenuCategory]

        public init(collection: UICollectionView, delegate: PlaceMenuControllerProtocol) {

            _collection = collection
            _delegate = delegate
            _categories = [MenuCategory]()

            super.init()

            PlaceMenuCategoryCell.register(in: _collection)
            _collection.dataSource = self
            _collection.delegate = self
        }

        // MARK: Interface
        public func update(range: [MenuCategory]) {

            _categories = range.sorted(by: { $0.orderNumber < $1.orderNumber })
            _collection.reloadData()
        }

        // MARK: UICollectionViewDataSource
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return _categories.count
        }
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let category = _categories[indexPath.row]
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: PlaceMenuCategoryCell.identifier, for: indexPath) as! PlaceMenuCategoryCell
            cell.update(by: category)

            if (indexPath.row == 0 && indexPath.section == 0) {
                cell.select()
            }

            return cell
        }

        // MARK: UICollectionViewDelegateFlowLayout
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return PlaceMenuCategoryCell.sizeOfCell(category: _categories[indexPath.row])
        }
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            for cell in _collection.visibleCells {
                if let cell = cell as? PlaceMenuCategoryCell {
                    cell.deselect()
                }
            }

            _collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            let cell = collectionView.cellForItem(at: indexPath) as! PlaceMenuCategoryCell
            cell.select()

            let category = _categories[indexPath.row]
            _delegate.select(category: category.ID)
        }
    }
}

// MARK: Dishes
extension PlaceMenuController {
    private class DishesAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let _table: UITableView
        private let _delegate: PlaceMenuControllerProtocol

        private var _dishes: [Dish]
        private var _filtered: [Dish]
        private var _categoryId: Long?

        private var _cells: [Long : PlaceMenuDishCell]
        private var _currency: CurrencyType

        public init(table: UITableView, delegate: PlaceMenuControllerProtocol) {

            _table = table
            _delegate = delegate

            _dishes = [Dish]()
            _filtered = [Dish]()
            _categoryId = nil

            _cells = [Long: PlaceMenuDishCell]()
            _currency = .All

            super.init()

            _table.delegate = self
            _table.dataSource = self
        }

        // MARK: Interface
        public func update(range: [Dish], currency: CurrencyType) {

            _dishes = range.sorted(by: { $0.orderNumber < $1.orderNumber  })
            _currency = currency

            reload()
        }
        public func filter(by categoryId: Long?) {

            _categoryId = categoryId
            reload()
        }
        public func reload() {

            if let categoryId = _categoryId {
                _filtered = _dishes.filter({ categoryId == $0.categoryId })
            } else {
                _filtered = _dishes
            }

            _table.reloadData()
        }
        public func clear() {
            _cells.removeAll()
        }

        // MARK: UITableViewDataSource
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return _filtered.count
        }
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return PlaceMenuDishCell.height
        }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let dish = _filtered[indexPath.row]
            if nil == _cells[dish.ID] {
                _cells[dish.ID] = PlaceMenuDishCell.instance(for: dish, with: _currency, delegate: _delegate)
            }

            return _cells[dish.ID]!
        }

        // MARK: UITableViewDelegate
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: true)

            _delegate.select(dish: _filtered[indexPath.row].ID)
        }

        // MARK: UIScrroolViewDelegate
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            _delegate.scrollTo(offset: scrollView.contentOffset.y )
        }
    }
}
