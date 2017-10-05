//
//  FavouritesController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import AsyncTask

public class FavouritesController: UIViewController {

    //MARK: UI Elements
    @IBOutlet public weak var Searchbar: UISearchBar!
    @IBOutlet public weak var TableView: UITableView!
    private var _loader: InterfaceLoader!


    //MARK: Data & Services
    private var _listAdapter: PlacesListAdapter!
    private var _tableAdapter: PlacesListTableAdapter!
    private var _cache: SearchPlaceCardsCacheService!
    private var _likesService: LikesService!
    private var _stored: [SearchPlaceCard] = []
    private var _isLoadData: Bool = false


    //MARK: View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)

        _listAdapter = PlacesListAdapter(source: self)
        _tableAdapter = PlacesListTableAdapter(source: TableView, delegate: _listAdapter)
        Searchbar.delegate = _tableAdapter
        _cache = ServicesFactory.shared.searchCards
        _likesService = ServicesFactory.shared.likes


        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
        loadData()
    }

    //MARK: Load data
    private func loadData() {

        if (self._isLoadData){
            return
        }
        self._isLoadData = true

        let liked = _likesService.all()
        let result = _cache.checkLocal(liked)
        if (result.cached.isEmpty) {
            _loader.show()
        }
        else {

            _stored = _cache.rangeInLocal(result.cached)
            _tableAdapter.update(places: _stored)
        }

        //WTF: Change on range API
        let task = _cache.all()
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self._loader.hide()
                self._stored = response ?? []
                self._tableAdapter.update(places: self._stored)

                if (nil == response) {
                    let alert = UIAlertController(title: "Ошибка", message: "Возникла ошибка при обновлении данных. Проверьте подключение к интернету или повторите позднее.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in

                    }))
                    self.navigationController?.present(alert, animated: false, completion: nil)
                }

                self._isLoadData = false
            }
        })
    }
}
