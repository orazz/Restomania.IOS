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

public class PlacesListTableAdapter: NSObject {

    private let _table: UITableView
    private let _delegate: PlacesListDelegate
    private var _sourcePlaces: [SearchPlaceCard]
    private var _cells: [Long: SearchPlaceCardCell]
    private var _filtered: [SearchPlaceCard]
    private var _filter: (([SearchPlaceCard]) -> [SearchPlaceCard])?

    public convenience init(source: UITableView, with controller: UIViewController) {
        self.init(source: source, delegate:  PlacesListAdapter(source: controller))
    }
    public init(source: UITableView, delegate: PlacesListDelegate) {

        _table = source
        SearchPlaceCardCell.register(in: source)

        _delegate = delegate
        _sourcePlaces = []
        _cells = [:]
        _filtered = []
        _filter = nil

        super.init()

        source.delegate = self
        source.dataSource = self
    }

    public func update(places: [SearchPlaceCard]) {

        self._sourcePlaces = places.sorted(by: { left, right in

            if (left.peopleCount == right.peopleCount) {
                return left.name < right.name
            }
            else {
                return left.peopleCount > right.peopleCount
            }
        })

        reload()

        if (0 != _table.numberOfRows(inSection: 0)) {
            _table.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    public func reload() {

        self._filtered = _filter?(_sourcePlaces) ?? _sourcePlaces

        self._table.reloadData()
    }
}

extension PlacesListTableAdapter: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _filtered.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let card = _filtered[indexPath.row]

        if (nil == _cells[card.ID]) {
            _cells[card.ID] = tableView.dequeueReusableCell(withIdentifier: SearchPlaceCardCell.identifier) as? SearchPlaceCardCell
        }

        let cell = _cells[card.ID]!
        cell.update(card: card, delegate: _delegate)

        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchPlaceCardCell.height
    }
}

extension PlacesListTableAdapter: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let place = _filtered[indexPath.row]
        _delegate.goTo(place: place.ID)
    }
}

extension PlacesListTableAdapter: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if (String.isNullOrEmpty(searchText)) {
            _filter = nil
        }
        else {
            _filter = { self._delegate.filter($0, by: searchText) }
        }

        reload()
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}



