//
//  SearchController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import AsyncTask
import IOSLibrary

public class SearchController: UIViewController {

    // MARK: UI elements
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var table: UITableView!
    private var loader: InterfaceLoader!
    private var refreshControl: RefreshControl!

    // MARK: Data & services
    private let _tag = String.tag(SearchController.self)
    private var loadQueue: AsyncQueue!
    private var tableAdapter: TableAdapter!
    private var searchAdapter: SearchAdapter<PlaceSummary>!
    private var service = CacheServices.places
    private var places: [PlaceSummary]!

    public override func viewDidLoad() {
        super.viewDidLoad()

        loader = InterfaceLoader(for: self.view)
        refreshControl = table.addRefreshControl(for: self, action: #selector(needReload))

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        tableAdapter = TableAdapter(for: self)
        searchAdapter = setupSearchAdapter()

        searchBar.delegate = self

        loadData()
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

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
    }

    internal func goTo(_ place: PlaceSummary) {

        let vc = PlaceMenuController.create(for: place.ID)
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

// MARK: Load
extension SearchController {

    private func loadData() {

        let ids = AppSummary.shared.placeIDs!
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

        let ids = AppSummary.shared.placeIDs!
        let task = service.range(ids)
        task.async(loadQueue, completion: { response in

            DispatchQueue.main.sync {

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
            self.tableAdapter.Update(places)
        }

        self.loader.hide()
        self.refreshControl.endRefreshing()
    }
}

// MARK: Search delegate
extension SearchController: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let filtered = searchAdapter.filter(phrase: searchBar.text, for: places)
        tableAdapter.Update(filtered)
    }
}

// MARK: Table adapter
extension SearchController {

    private class TableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

        private let table: UITableView
        private let delegate: SearchController
        private var places: [PlaceSummary]

        public init(for delegate: SearchController) {

            self.table = delegate.table
            self.delegate = delegate
            self.places = [PlaceSummary]()

            super.init()

            SearchPlaceCard.register(in: table)
            table.delegate = self
            table.dataSource = self
        }

        public func Update(_ places: [PlaceSummary]) {
            self.places = places
            table.reloadData()
        }

        // MARK: UITableViewDelegate
        public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: true)
            delegate.goTo(places[indexPath.row])
        }

        // MARK: UITableViewDataSource
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return places.count
        }
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return SearchPlaceCard.height
        }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: SearchPlaceCard.identifier, for: indexPath) as! SearchPlaceCard
            cell.update(summary: places[indexPath.row])

            return cell
        }
    }
}
