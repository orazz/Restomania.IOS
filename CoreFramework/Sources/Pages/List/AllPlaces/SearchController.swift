//
//  SearchController.swift
//  CoreFramework
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

internal class SearchController: BaseSearchController {

    // UI
    private var searchController: UISearchController!
    private var resultsTableController = BaseSearchController()
    private var resultsUpdater = SearchResultsUpdater()
    private var searchBar: UISearchBar!
    private var loader: InterfaceLoader!

    // Services
    private let router = DependencyResolver.get(Router.self)
    private let configs = DependencyResolver.get(ConfigsContainer.self)
    private let service = DependencyResolver.get(PlacesCacheService.self)
    private let themeColors = DependencyResolver.get(ThemeColors.self)

    // Data
    private let _tag = String.tag(SearchController.self)
    private var loadQueue: AsyncQueue

    internal override init(){

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        super.init()

        places = service.cache.all
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        super.loadView()

        configureSearchController()
        loadMarkup()
    }
    private func loadMarkup() {

        searchBar = searchController.searchBar
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = themeColors.navigationContent
        searchBar.barTintColor = themeColors.navigationContent
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = themeColors.navigationContent

        refreshControl = tableView.addRefreshControl(for: self, action: #selector(needReload))

        loader = InterfaceLoader(for: self.view)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationController?.setStatusBarStyle(from: themeColors.statusBarOnNavigation)
    }

    private func configureSearchController() {

        resultsTableController.tableView.delegate = self

        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = resultsUpdater
        searchController.delegate = self
        searchController.searchBar.delegate = self

        definesPresentationContext = true
    }

    public override func update(by places: [PlaceSummary]) {
        super.update(by: places)

        resultsUpdater.places = places
    }
}
extension SearchController: UISearchBarDelegate {}
extension SearchController: UISearchControllerDelegate {}

// MARK: Load
extension SearchController {

    private func setupSearchAdapter() -> SearchAdapter<PlaceSummary> {
        let adapter = SearchAdapter<PlaceSummary>()

        adapter.add({ $0.Name })
        adapter.add({ $0.Description })
        adapter.add({ $0.Location.address })
        adapter.add({ $0.Location.city })
        adapter.add({ $0.Location.street })
        adapter.add({ $0.Location.house })

        return adapter
    }

    private func loadData() {

        if (places.isEmpty) {
            loader.show()
        }
        else {
            completeLoad(places)
        }

        requestPlaces()
    }
    @objc private func needReload() {
        requestPlaces()
    }
    private func requestPlaces() {

        var request: RequestResult<[PlaceSummary]>? = nil
        if let chainId = configs.chainId {
            request = service.chain(chainId)
        } else {
            request = service.all()
        }

        request?.async(loadQueue, completion: { response in
            DispatchQueue.main.async {

                if (response.isFail) {
                    self.alert(about: response)
                    return
                }

                self.completeLoad(response.data!)
            }
        })
    }
    private func completeLoad(_ places: [PlaceSummary]) {

        update(by: places)

        loader.hide()
        refreshControl?.endRefreshing()
    }
}

extension SearchController {
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        if let cell = tableView.cellForRow(at: indexPath) as? SearchPlaceCard,
            let summary = cell.summary {
            
            router.goToPlaceMenu(placeId: summary.id)
        }
    }
}
fileprivate class SearchResultsUpdater: NSObject, UISearchResultsUpdating {

    public var places: [PlaceSummary]

    private var searchAdapter: SearchAdapter<PlaceSummary>!

    internal override init() {

        places = []

        searchAdapter = SearchAdapter<PlaceSummary>()
        searchAdapter.add({ $0.Name })
        searchAdapter.add({ $0.Description })
        searchAdapter.add({ $0.Location.address })
        searchAdapter.add({ $0.Location.city })
        searchAdapter.add({ $0.Location.street })
        searchAdapter.add({ $0.Location.house })
    }

    public func updateSearchResults(for searchController: UISearchController) {

        let phrase = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let filtered = searchAdapter.filter(phrase: phrase, for: places)

        if let results = searchController.searchResultsController as? BaseSearchController  {
            results.update(by: filtered)
        }
    }
}
extension SearchController {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(SearchController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        //Status
        case labelsTitle = "Labels.Title"
        case labelsSearchBarPlaceholder = "Labels.SearchPlaceHolder"
    }
}
