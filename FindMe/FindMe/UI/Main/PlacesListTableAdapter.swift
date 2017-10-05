//
//  PlacesListTableAdapter.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlacesListTableAdapter: NSObject, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    private let _table: UITableView
    private let _delegate: PlacesListDelegate
    private var _sourcePlaces: [SearchPlaceCard]
    private var _filtered: [SearchPlaceCard]
    private var _filter: (([SearchPlaceCard]) -> [SearchPlaceCard])?

    public init(source: UITableView, delegate: PlacesListDelegate) {

        _table = source
        SearchPlaceCardCell.register(in: source)

        _delegate = delegate
        _sourcePlaces = []
        _filtered = []
        _filter = nil

        super.init()

        source.delegate = self
        source.dataSource = self
    }

    public func update(places: [SearchPlaceCard]) {

        self._sourcePlaces = places

        reload()
    }
    public func reload() {

        self._filtered = _filter?(_sourcePlaces) ?? _sourcePlaces

        self._table.reloadData()
    }

    //MARK: UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _filtered.count
    }

    //MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPlaceCardCell.identifier, for: indexPath) as! SearchPlaceCardCell
        cell.setup(card: _filtered[indexPath.row], delegate: _delegate)

        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchPlaceCardCell.height
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let place = _filtered[indexPath.row]
        _delegate.goTo(place: place.ID)
    }

    //MARK: UISearchBarDelegate
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if (String.isNullOrEmpty(searchText)) {
            _filter = nil
        }
        else {
            _filter = { self._delegate.filter($0, by: searchText) }
        }

        reload()
    }
}
