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
    private let _tag = String.tag(FavouritesController.self)
    private let _guid = Guid.new
    private var _listAdapter: PlacesListAdapter!
    private var _tableAdapter: PlacesListTableAdapter!
    private var _cache: SearchPlaceCardsCacheService!
    private var _likesService: LikesService!
    private var _stored: [SearchPlaceCard]! {
        didSet {
            _tableAdapter.update(places: _stored)
        }
    }
    private var _isLoadData: Bool = false


    //MARK: View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)

        _listAdapter = PlacesListAdapter(source: self)
        _tableAdapter = PlacesListTableAdapter(source: TableView, delegate: _listAdapter)
        Searchbar.delegate = _tableAdapter
        _cache = CacheServices.searchCards
        _likesService = ServicesFactory.shared.likes

        _likesService.subscribe(guid: _guid, handler: self, tag: _tag)

        loadData()
    }
    deinit {
        _likesService.unsubscribe(guid: _guid)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    //MARK: Load data
    private func loadData() {

        if (self._isLoadData){
            return
        }

        let liked = _likesService.all()
        let result = _cache.checkLocal(liked)
        if (result.cached.isEmpty) {
            _loader.show()

            _stored = []
        }
        else {

            _stored = _cache.rangeInLocal(result.cached)
            _tableAdapter.update(places: _stored)
        }

        if (result.notFound.isEmpty) {
            _loader.hide()
            return
        }

        //WTF: Change on range API
        self._isLoadData = true
        let task = _cache.allRemote(with: SelectParameters())
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self._loader.hide()

                if let response = response {

                    self._stored = response
                }
                else if(!liked.isEmpty && self._stored.isEmpty) {

                    let alert = UIAlertController(title: "Ошибка", message: "Возникла ошибка при обновлении данных. Проверьте подключение к интернету или повторите позднее.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                }

                self._isLoadData = false
            }
        })
    }
}

//MARK: LikesServiceDelegate
extension FavouritesController: LikesServiceDelegate {

    public func change(placeId: Long, isLiked: Bool) {

        DispatchQueue.main.async {
            self._tableAdapter.reload()
        }
    }
}
