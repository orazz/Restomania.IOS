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

public class PlaceMenuController: UIViewController {

    public static let nibName = "PlaceMenuController"

    public var placeID: Long = -1

    private let _tag = "PlaceMenuController"

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

    private let _theme = AppSummary.current.theme
    private var _categoriesAdapter: CategoriesCollection!
    private var _dishesAdapter: DishesAdapter!

    //Load data
    private var _summary: PlaceSummary?
    private var _summaryCompleteRequest = false
    private var _menu: MenuSummary?
    private var _menuCompleteRequest = false
    private var _cart: Cart!

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUIElements()
        tryHideLoader()

        Log.Info(_tag, "Load place's menu of #\(placeID).")
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()

        _loader = InterfaceLoader(for: self.view)
        _loader.show()

        _categoriesAdapter = CategoriesCollection(source: self)
        _dishesAdapter = DishesAdapter(source: self)

        _cart = ServicesManager.current.cartsService.cart(placeID: placeID)
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
        view.backgroundColor = _theme.backgroundColor
        dimmer.backgroundColor = _theme.backgroundColor

        //Title view
        // - round borders
        titleView.layer.cornerRadius = 5
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = _theme.whiteColor.cgColor
        titleView.backgroundColor = _theme.whiteColor
        // - shadow
        titleView.layer.shadowColor = _theme.blackColor.cgColor
        titleView.layer.shadowOpacity = 0.13
        titleView.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        titleView.layer.shadowRadius = 5
        titleView.layer.shouldRasterize = true

        //Back button
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.goBack))
        backButton.addGestureRecognizer(tap)
        backButton.isUserInteractionEnabled = true

        //Name
        placeName.font = UIFont(name: _theme.susanBoldFont, size: _theme.titleFontSize)
        placeName.textColor = _theme.blackColor

        //Wokings hours
        placeWorkingHours.font = UIFont(name: _theme.susanBookFont, size: _theme.captionFontSize)
        placeWorkingHours.textColor = _theme.blackColor

        //Menu

    }
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    //Load summary
    private func requestSummary() {

        let service = ServicesManager.current.placeSummariesService
        _summary = service.findInLocal(placeID)

        //Take local
        if (nil != _summary) {
            applySummary()
            return
        }

        //Take remote
        let task = service.range([ placeID ])
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
            if (String.IsNullOrEmpty(day)) {
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
        _menu = service.findInLocal(placeID)

        //Take local
        if (nil != _menu) {
            applyMenu()
            return
        }

        //Take remote
        let task = service.find(placeID: placeID)
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
    private func selectCategory(_ id: Long) {
        Log.Debug(_tag, "Select category #\(id)")
    }
    private func add(dish id: Long) {
        Log.Debug(_tag, "Add dish #\(id)")
    }

    private func tryHideLoader() {

        if (nil != _summary && nil != _menu) {
            _loader.hide()
        }

        if (nil == _summary && _summaryCompleteRequest ||
            nil == _menu && _menuCompleteRequest) {
            Log.Error(_tag, "Problem with load data for page.")

            let alert = UIAlertController(title: "Ошибка", message: "У нас возникла проблема с закгрузкой данныхю", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            self.navigationController?.popViewController(animated: true)
        }
    }

    private class CategoriesCollection: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let _source: PlaceMenuController
        private let _collection: UICollectionView
        private var _data: [DishCategory]

        public init(source: PlaceMenuController) {
            _source = source
            _collection = source.categoriesStack
            _data = [DishCategory]()

            super.init()

            let nib = UINib(nibName: DishCategoryCard.nibName, bundle: nil)
            _collection.register(nib, forCellWithReuseIdentifier: DishCategoryCard.identifier)
            _collection.dataSource = self
            _collection.delegate = self
        }

        public func update(range: [DishCategory]) {

            _data = range.sorted(by: { $0.OrderNumber > $1.OrderNumber })
            _collection.reloadData()
        }

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return _data.count
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: DishCategoryCard.identifier, for: indexPath) as! DishCategoryCard
            cell.setup(category: _data[indexPath.row], handler: { id, card in self.selectCategory(id, sender: card, index: indexPath) })

            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return DishCategoryCard.sizeOfCell(category: _data[indexPath.row])
        }
        private func selectCategory(_ id: Long, sender: DishCategoryCard, index: IndexPath) {

            for cell in _collection.visibleCells {
                if let cell = cell as? DishCategoryCard {

                    cell.unSelect()
                }
            }
            sender.select()
            _collection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)

            _source.selectCategory(id)
        }
    }
    private class DishesAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let _source: PlaceMenuController
        private let _table: UITableView
        private var _data: [Dish]
        private let _celNib = UINib(nibName: MenuDishCard.nibName, bundle: nil)
        private var _cells: [Int:MenuDishCard]
        private var _currency: CurrencyType

        public init(source: PlaceMenuController) {

            _source = source
            _table = source.dishesTable
            _data = [Dish]()
            _cells = [Int: MenuDishCard]()
            _currency = .All

            super.init()

            _table.delegate = self
            _table.dataSource = self
        }

        public func update(range: [Dish], currency: CurrencyType) {

            _data = range.sorted(by: { $0.OrderNumber > $1.OrderNumber  })
            _currency = currency
            _table.reloadData()
        }

        //Delegates
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return _data.count
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return MenuDishCard.height
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if let cell = _cells[indexPath.row] {

                return cell
            }

            let cell = _celNib.instantiate(withOwner: nil, options: nil).first as! MenuDishCard
            _cells[indexPath.row] = cell
            cell.setup(dish: _data[indexPath.row], currency: _currency, handler: { self._source.add(dish: $0) })

            return cell
        }
    }
}
