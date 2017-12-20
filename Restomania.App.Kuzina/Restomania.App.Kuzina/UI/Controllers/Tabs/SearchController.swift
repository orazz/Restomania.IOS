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

public class SearchController: UIViewController, UISearchBarDelegate {

    // MARK: UI elements
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!

    // MARK: Data & services
    private let _tag = String.tag(SearchController.self)
    private let loadQueue: AsyncQueue!
    private var _loader: InterfaceLoader!
    private var _tableAdapter: TableAdapter!
    private var _searchAdapter: SearchAdapter<PlaceSummary>!
    private var _service = CacheServices.places
    private var _data: [PlaceSummary]!

    public override func viewDidLoad() {
        super.viewDidLoad()

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        _loader = InterfaceLoader(for: self.view)
        _tableAdapter = TableAdapter(source: self)
        _searchAdapter = setupSearchAdapter()

        searchBar.delegate = self

        loadData()

    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
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
    private func loadData() {

        let ids = AppSummary.shared.placeIDs!

        //Take local data
        let result = _service.cache.check(ids)
        if (result.cached.isEmpty) {
            _loader.show()
        }
        else {
            completeLoad(result.cached)
        }

        //Request remote
        let task = _service.range(ids)
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
            self._data = places
            self._tableAdapter.Update(places)
        }

        self._loader.hide()
    }

    internal func goTo(placeId: Long) {

        let vc = PlaceMenuController.create(for: placeId)

        self.navigationController!.pushViewController(vc, animated: true)
    }

    //SearchBar delegate
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let filtered = _searchAdapter.filter(phrase: searchBar.text ?? String.empty, for: _data)

        _tableAdapter.Update(filtered)
    }

    private class TableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {

        private let _table: UITableView
        private let _source: SearchController
        private var _data: [PlaceSummary]

        public init(source: SearchController) {
            _source = source
            _table = source.table
            _data = [PlaceSummary]()

            super.init()

            let nib = UINib.init(nibName: PlaceCard.nibName, bundle: nil)
            _table.register(nib, forCellReuseIdentifier: PlaceCard.identifier)
            _table.delegate = self
            _table.dataSource = self
        }

        public func Update(_ data: [PlaceSummary]) {
            _data = data
            _table.reloadData()
        }

        //Delegate
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return _data.count
        }
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return PlaceCard.height
        }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCard.identifier, for: indexPath) as! PlaceCard
            cell.initialize(summary: _data[indexPath.row], touchAction: { self._source.goTo(placeId: $0) })

            return cell
        }
    }
}
