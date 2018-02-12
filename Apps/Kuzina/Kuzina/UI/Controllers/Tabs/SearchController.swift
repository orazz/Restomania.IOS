//
//  SearchController.swift
//  Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit
import CoreDomains

public class SearchController: UIViewController {

    // MARK: UI elements
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var placesTable: UITableView!
    private var loader: InterfaceLoader!
    private var refreshControl: RefreshControl!

    // MARK: Data & services
    private let _tag = String.tag(SearchController.self)
    private var loadQueue: AsyncQueue!
    private var searchAdapter: SearchAdapter<PlaceSummary>!
    private var service = CacheServices.places
    private var places: [PlaceSummary]! {
        didSet {
            updateFiltered()
        }
    }
    private var filtered: [PlaceSummary]!

    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()
        startLoadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
    }
}

// MARK: Load
extension SearchController {

    private func loadMarkup() {

        searchBar.delegate = self

        placesTable.delegate = self
        placesTable.dataSource = self
        SearchPlaceCard.register(in: placesTable)

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        loader = InterfaceLoader(for: self.view)
        searchAdapter = setupSearchAdapter()
        refreshControl = placesTable.addRefreshControl(for: self, action: #selector(needReload))
    }
    private func setupSearchAdapter() -> SearchAdapter<PlaceSummary> {
        let adapter = SearchAdapter<PlaceSummary>()

        adapter.add({ $0.Name })
        adapter.add({ $0.Description })
        adapter.add({ $0.Location.City })
        adapter.add({ $0.Location.Street })
        adapter.add({ $0.Location.House })

        return adapter
    }

    private func startLoadData() {

        let ids = AppSettings.shared.placeIDs!
        let cached = service.cache.range(ids)

        if (cached.isEmpty) {
            loader.show()
        }
        completeLoad(cached)

        requestPlaces()
    }
    @objc private func needReload() {
        requestPlaces()
    }
    private func requestPlaces() {

        let ids = AppSettings.shared.placeIDs!
        let task = service.range(ids)
        task.async(loadQueue, completion: { response in

            DispatchQueue.main.async {

                if (response.isFail) {
                    let alert = ProblemAlerts.error(for: response)
                    self.present(alert, animated: true, completion: nil)
                }

                self.completeLoad(response.data)
            }
        })
    }
    private func completeLoad(_ places: [PlaceSummary]?) {

        if let places = places {
            self.places = places
        }

        self.loader.hide()
        self.refreshControl.endRefreshing()
    }
}

// MARK: Search delegate
extension SearchController: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateFiltered()
    }
    private func updateFiltered() {

        filtered = searchAdapter.filter(phrase: searchBar.text, for: places)
        placesTable.reloadData()
    }
}

// MARK: Table adapter
extension SearchController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let place = filtered[indexPath.row]
        let vc = PlaceMenuController(for: place.ID)
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
extension SearchController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchPlaceCard.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPlaceCard.identifier, for: indexPath) as! SearchPlaceCard
        cell.update(summary: filtered[indexPath.row])

        return cell
    }
}
