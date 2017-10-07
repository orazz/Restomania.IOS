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

        return instance
    }


    //MARK: UIElements
    @IBOutlet weak var ContentView: UITableView!
    private var _loader: InterfaceLoader!

    //MARK: Data
    private var _placeId: Long!
    private var _cache: PlacesCacheservice!
    private var _source: Place? = nil
    private var _interfaceAdapter: InterfaceTable!


    //View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)
        _interfaceAdapter = InterfaceTable(source: ContentView, navigator: self.navigationController!)

        buildRows()
        loadData()
    }
    private func buildRows() {

        _interfaceAdapter.add(OnePlaceMainTitleCell.instance)
        _interfaceAdapter.add(OnePlaceMainSliderCell.instance)
        _interfaceAdapter.add(OnePlaceMainAddressCell.instance)
        _interfaceAdapter.add(OnePlaceMainStatisticCell.instance)
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
    }


    //MARK: Actions
    @IBAction public func goBack() {

        self.navigationController?.popViewController(animated: true)
    }
}
