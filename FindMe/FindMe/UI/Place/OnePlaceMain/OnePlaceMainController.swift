//
//  OnePlaceController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

internal protocol OnePlaceMainCellProtocol: InterfaceTableCellProtocol {

    func update(by: Place)
}
public class OnePlaceMainController: UIViewController {

    private static let nibName = "OnePlaceMainView"
    public static func build(placeId: Long) -> OnePlaceMainController {

        let instance = OnePlaceMainController(nibName: nibName, bundle: Bundle.main)

        instance._placeId = placeId
        instance._cache = ServicesFactory.shared.places
        instance._likes = ServicesFactory.shared.likes

        return instance
    }


    //MARK: UIElements
    @IBOutlet weak var ContentView: UITableView!
    @IBOutlet weak var LikeButton: UIBarButtonItem!
    private var _loader: InterfaceLoader!

    //MARK: Data
    private var _placeId: Long!
    private var _cache: PlacesCacheservice!
    private var _likes: LikesService!
    private var _source: Place? = nil
    private var _interfaceAdapter: InterfaceTable!


    //View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)
        _interfaceAdapter = InterfaceTable(source: ContentView, navigator: self.navigationController!)

        setupLikeButton()
        buildRows()
        loadData()
    }
    private func setupLikeButton() {

        var image = ThemeSettings.Images.heartInactive
        if (_likes.isLiked(place: _placeId)){

            image = ThemeSettings.Images.heartActive
        }

        LikeButton.image = image.withRenderingMode(.alwaysOriginal)
    }
    private func buildRows() {

        _interfaceAdapter.add(OnePlaceMainTitleCell.instance)
        _interfaceAdapter.add(OnePlaceMainSliderCell.instance)
        _interfaceAdapter.add(OnePlaceMainAddressCell.instance)
        _interfaceAdapter.add(OnePlaceMainStatisticCell.instance)

        let description = OnePlaceMainDescriptionCell.instance
        _interfaceAdapter.add(description)
        _interfaceAdapter.add(OnePlaceMainDividerCell.instance(for: description))

//        let actions = OnePlaceMainContactsCell.instance
//        _interfaceAdapter.add(actions)
//        _interfaceAdapter.add(OnePlaceMainDividerCell.instance(for: actions))

        let contacts = OnePlaceMainContactsCell.instance
        _interfaceAdapter.add(contacts)
        _interfaceAdapter.add(OnePlaceMainDividerCell.instance(for: contacts))

        _interfaceAdapter.add(OnePlaceMainLocationCell.instance)

        _interfaceAdapter.add(OnePlaceMainSpaceCell.instance)
    }
    private func loadData() {

        if let place = _cache.findLocal(id: _placeId){
            _source = place
            update(by: place)
        }
        else {
            _loader.show()
        }


        let task = _cache.findRemote(id: _placeId)
        task.async(.background, completion: { response in
            DispatchQueue.main.async {

                guard let place = response else {

                    self.goBack()

                    let alert = UIAlertController(title: "Ошибка", message: "Проблемы с получение данных заведения. Проверьте подключение к интернету и попробуйте позже.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.navigationController?.present(alert, animated: true, completion: nil)

                    return
                }


                self._source = place
                self.update(by: place)

                self._loader.hide()
            }
        })
    }
    private func update(by place: Place) {

        for it in _interfaceAdapter.rows {
            if let cell = it as? OnePlaceMainCellProtocol {
                cell.update(by: place)
            }
        }

        _interfaceAdapter.reload()
    }


    //MARK: Actions
    @IBAction public func goBack() {

        self.navigationController?.popViewController(animated: true)
    }
    @IBAction public func likePlace() {

        if (_likes.isLiked(place: _placeId)){
            _likes.unlike(place: _placeId)
        }
        else {
            _likes.like(place: _placeId)
        }

        setupLikeButton()
    }
}
public class OnePlaceMainSubheadLabel: FMSubheadLabel {

    public override func initialize() {
        super.initialize()

        textColor = ThemeSettings.Colors.main
        font = ThemeSettings.Fonts.bold(size: .subhead)
    }
}
