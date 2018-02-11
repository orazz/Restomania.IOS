//
//  SearchController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit


public class SearchController: UIViewController {

    //MARK: UI Elements
    @IBOutlet public weak var placeTypeSegment: UISegmentedControl!
    @IBOutlet public weak var searchbar: UISearchBar!
    @IBOutlet public weak var placesTable: UITableView!
    private var tableAdapter: PlacesListTableAdapter!
    private var loader: InterfaceLoader!
    private var refreshControl: UIRefreshControl!

    //MARK: Data & Services
    private let _tag = String.tag(SearchController.self)
    private let guid = Guid.new
    private var loadQueue: AsyncQueue!
    private var displayFlag = DisplayPlacesFlag.all
    private var searchCardsCache = CacheServices.searchCards
    private var towns = LogicServices.shared.towns
    private var likes = LogicServices.shared.likes
    private var isNeedReload: Bool = false
    private var places = [SearchPlaceCard]() {
        didSet {
            refreshList()
        }
    }


    //MARK: View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        likes.subscribe(guid: guid, handler: self, tag: _tag)
        towns.subscribe(guid: guid, handler: self, tag: _tag)

        loadMarkup()
        startLoadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (isNeedReload) {
            startLoadData()
            isNeedReload = false
        }

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    deinit {
        likes.unsubscribe(guid: guid)
        towns.unsubscribe(guid: guid)
    }
    private func loadMarkup() {

        loader = InterfaceLoader(for: self.view)
        tableAdapter = PlacesListTableAdapter(source: placesTable, with: self)

        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = ThemeSettings.Colors.background
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(needRefreshData), for: .valueChanged)
        placesTable.addSubview(refreshControl)

        placeTypeSegment.addTarget(self, action: #selector(updateSegment), for: .valueChanged)
        searchbar.delegate = tableAdapter

        navigationController?.setToolbarHidden(true, animated: false)
    }


    //MARK: Load data
    private func startLoadData() {

        if let towns = takeSelectedTowns() {
            let filtered = searchCardsCache.cache.all.filter{  nil != $0.townId }
            places = filtered.filter{ towns.contains($0.townId!) }
        }
        else {
            places = searchCardsCache.cache.all
        }

        requestPlaces()
    }
    @objc private func needRefreshData() {
        requestPlaces()
    }
    private func requestPlaces() {

        let towns = takeSelectedTowns()
        let task = searchCardsCache.all(with: SelectParameters(), in: towns)
        task.async(loadQueue, completion: { result in
            DispatchQueue.main.async {

                if result.isFail {
                    self.present(ProblemAlerts.Error(for: result.statusCode), animated: true, completion: { self.completeLoad(with: result.data) })
                }
                else if result.isSuccess {
                    self.completeLoad(with: result.data)
                }
            }
        })
    }
    private func completeLoad(with places: [SearchPlaceCard]?) {

        if (refreshControl.isRefreshing){
            refreshControl.endRefreshing()
        }

        self.places = places ?? searchCardsCache.cache.all
    }
    private func refreshList() {

        if (displayFlag == .all) {
            tableAdapter?.update(places: places)
        }
        else if (displayFlag == .onlyLiked) {
            tableAdapter?.update(places: likes.filterLiked(places))
        }
    }
    private func takeSelectedTowns() -> [Long]? {

        let towns = self.towns.all()
        if (towns.isEmpty) {
            return nil
        }

        return towns
    }
}

//MARK: UISegmentedControl
extension SearchController {
    @objc private func updateSegment() {

        switch placeTypeSegment.selectedSegmentIndex {
            case 0:
                displayFlag = .all
            case 1:
                displayFlag = .onlyLiked
            default:
                return
        }

        refreshList()
    }
}

//MARK:
extension SearchController: SelectedTownsServiceDelegate {

    public func selectedTownsService(_: SelectedTownsService, select: Long) {
        changeSelectedTowns()
    }
    public func selectedTownsService(_: SelectedTownsService, unselect: Long) {
        changeSelectedTowns()
    }
    private func changeSelectedTowns() {

        if (self.isBeingPresented) {
            DispatchQueue.main.async {
                self.startLoadData()
            }
        }
        else {
            isNeedReload = true
        }
    }
}

//MARK: LikesServiceDelegate
extension SearchController: LikesServiceDelegate {

    public func change(placeId: Long, isLiked: Bool) {

        DispatchQueue.main.async {
            if (self.displayFlag == .onlyLiked) {
                self.refreshList()
            }
        }
    }
}
