//
//  SearchController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import AsyncTask


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
    private var cacheService = CacheServices.searchCards
    private var likes = LogicServices.shared.likes
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

        loadMarkup()
        startLoadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    deinit {
        likes.unsubscribe(guid: guid)
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

        places = cacheService.cache.all

        requestPlaces()
    }
    @objc private func needRefreshData() {
        requestPlaces()
    }
    private func requestPlaces() {

        let task = cacheService.all(with: SelectParameters())
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

        self.places = places ?? cacheService.cache.all
    }
    private func refreshList() {

        if (displayFlag == .all) {
            tableAdapter?.update(places: places)
        }
        else if (displayFlag == .onlyLiked) {
            tableAdapter?.update(places: likes.filterLiked(places))
        }
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
