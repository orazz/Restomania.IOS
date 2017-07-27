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
    @IBOutlet weak var placeImage: WrappedImage!
    @IBOutlet weak var dimmer: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeWorkingHours: UILabel!

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var categoriesView: UIScrollView!
    @IBOutlet weak var dishesTable: UITableView!

    //Styles
    private let _theme = AppSummary.current.theme

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
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()

        _loader = InterfaceLoader(for: self.view)
        _loader.show()

        _cart = ServicesManager.current.cartsService.cart(placeID: placeID)
        requestSummary()
        requestMenu()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    private func setupUIElements() {

        //View
        view.backgroundColor = _theme.backgroundColor
        dimmer.backgroundColor = _theme.backgroundColor

        //Title view
        // - round borders
        titleView.layer.cornerRadius = 4
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = _theme.whiteColor.cgColor
        titleView.backgroundColor = _theme.whiteColor
        // - shadow
        titleView.layer.shadowColor = _theme.blackColor.cgColor
        titleView.layer.shadowOpacity = 0.13
        titleView.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        titleView.layer.shadowRadius = 5
        titleView.layer.shouldRasterize = true

        //Name
        placeName.font = UIFont(name: _theme.susanBoldFont, size: _theme.titleFontSize)
        placeName.textColor = _theme.blackColor

        //Wokings hours
        placeWorkingHours.font = UIFont(name: _theme.susanBookFont, size: _theme.captionFontSize)
        placeWorkingHours.textColor = _theme.blackColor

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
//            if let navbar = navigationController?.navigationBar {
//
////                navbar.topItem?.title = summary.Name
////                navbar.topItem?.prompt = "fuck"
//            }

            placeImage.setup(url: summary.Image)
            placeName.text = summary.Name

            var day = summary.Schedule.takeToday()
            if (String.IsNullOrEmpty(day)) {
                day = NSLocalizedString("holiday", comment: "Schedule")
            }

            placeWorkingHours.text = day
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

        let view = UIView(
        
        tryHideLoader()
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
}
