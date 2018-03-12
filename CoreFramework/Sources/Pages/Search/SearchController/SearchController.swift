//
//  SearchController.swift
//  Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class SearchController: UIViewController {

    // MARK: UI elements
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var placesTable: UITableView!
    private var loader: InterfaceLoader!
    private var refreshControl: RefreshControl!
    private var searchCardTemplate: TemplateContainer!


    // MARK: Services
    private let configs = DependencyResolver.resolve(ConfigsContainer.self)
    private let service = DependencyResolver.resolve(PlacesCacheService.self)
    private var searchAdapter: SearchAdapter<PlaceSummary>!

    // MARK: Data & services
    private let _tag = String.tag(SearchController.self)
    private var loadQueue: AsyncQueue!
    private var places: [PlaceSummary]! {
        didSet { updateFiltered() }
    }
    private var filtered: [PlaceSummary]!
    private let searchController = UISearchController(searchResultsController: nil)


    public init(){
        super.init(nibName: String.tag(SearchController.self), bundle: Bundle.coreFramework)

        searchCardTemplate = TemplateStore.shared.get(for: .searchPlaceCard)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()
        startLoadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.title = Localization.labelsTitle.localized
        self.edgesForExtendedLayout = []
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

// MARK: Load
extension SearchController {

    private func loadMarkup() {

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Localization.labelsSearchBarPlaceholder.localized
        definesPresentationContext = true

        // Setup the Scope Bar
        searchController.searchBar.delegate = self


        placesTable.delegate = self
        placesTable.dataSource = self
        searchCardTemplate.register(in: placesTable)

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        loader = InterfaceLoader(for: self.view)
        searchAdapter = setupSearchAdapter()
        refreshControl = placesTable.addRefreshControl(for: self, action: #selector(needReload))
    }
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

    private func startLoadData() {

        let cached = service.cache.all
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

        var request: RequestResult<[PlaceSummary]>? = nil
        if let chainId = configs.chainId {
            request = service.chain(chainId)
        } else {
            request = service.all()
        }

        request?.async(loadQueue, completion: { response in

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
extension SearchController: UISearchResultsUpdating, UISearchBarDelegate {
    public func updateSearchResults(for searchController: UISearchController) {
        updateFiltered()
    }
    private func updateFiltered() {

        if let phrase = searchController.searchBar.text,
            !String.isNullOrEmpty(phrase) {
            filtered = searchAdapter.filter(phrase: searchBar.text, for: places)
        }
        else {
            filtered = places
        }

        placesTable.reloadData()
    }
}

// MARK: Table adapter
extension SearchController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let place = filtered[indexPath.row]
        let vc = PlaceMenuController(for: place.id)
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

        let cell = tableView.dequeueReusableCell(withIdentifier: searchCardTemplate.identifier, for: indexPath) as! SearchPlaceCard
        cell.update(summary: filtered[indexPath.row])

        return cell
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
