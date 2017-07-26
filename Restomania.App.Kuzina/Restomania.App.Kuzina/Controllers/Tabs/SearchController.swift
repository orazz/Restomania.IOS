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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!

    private var _tableAdapter: TableAdapter!
    private var _searchAdapter: SearchAdapter<PlaceSummary>!
    private var _service: CachePlaceSummariesService!
    private var _data: [PlaceSummary]!

    public override func viewDidLoad() {
        super.viewDidLoad()

//        let control = UIRefreshControl()
//        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        control.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
//        table.addSubview(control)

        _tableAdapter = TableAdapter(source: self)
        _searchAdapter = setupSearchAdapter()
        _service = ServicesManager.current.placeSummariesService

        searchBar.delegate = self

        loadData()
    }
//    public func refresh(sender: AnyObject) {
//        Log.Debug("fuck", "work")
//    }

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

        let ids = AppSummary.current.placeIDs!

        //Take local data
        let checked = _service.checkCache(ids)
        _data = _service.rangeLocal(checked.cached)
        _tableAdapter.Update(_data)

        if (checked.notFound.isEmpty) {

            return
        }

        //Request remote
        let task = _service.range(ids)
        task.async(.utility, completion: { data in

            DispatchQueue.main.sync {
                self._data = data
                self._tableAdapter.Update(data)
            }
        })
    }

    //SearchBar delegate
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let filtered = _searchAdapter.filter(phrase: searchBar.text ?? String.Empty, for: _data)

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

            let nib = UINib.init(nibName: PlaceCard.xibName, bundle: nil)
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

            cell.initialize(summary: _data[indexPath.row])

            return cell
        }
    }
}
