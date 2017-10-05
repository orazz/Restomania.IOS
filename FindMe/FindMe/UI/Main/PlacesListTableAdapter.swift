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
    private var _cachedCells: [SearchPlaceCardCell?]
    private var _sourcePlaces: [SearchPlaceCard]
    private var _filtered: [SearchPlaceCard]
    private var _filter: (([SearchPlaceCard]) -> [SearchPlaceCard])?

    public init(source: UITableView, delegate: PlacesListDelegate) {

        _table = source
        SearchPlaceCardCell.register(in: source)

        _delegate = delegate
        _cachedCells = []
        _sourcePlaces = []
        _filtered = []
        _filter = nil

        super.init()

        source.delegate = self
        source.dataSource = self
    }

    public func update(places: [SearchPlaceCard]) {

        self._sourcePlaces = places.sorted(by: { $0.name > $1.name })

        reload()
    }
    public func reload() {

        self._filtered = _filter?(_sourcePlaces) ?? _sourcePlaces
        self._cachedCells = [SearchPlaceCardCell?].init(repeating: nil, count: _filtered.count)

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

        if let cell = _cachedCells[indexPath.row] {
            return cell
        }

        let cell = SearchPlaceCardCell(style: .default, reuseIdentifier: SearchPlaceCardCell.identifier)
        cell.setup(card: _filtered[indexPath.row], delegate: _delegate)
        _cachedCells[indexPath.row] = cell

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
