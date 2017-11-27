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


public class SearchController: UIViewController {

    //MARK: UI Elements
    @IBOutlet public weak var placeTypeSegment: UISegmentedControl!
    @IBOutlet public weak var searchbar: UISearchBar!
    @IBOutlet public weak var placesTable: UITableView!
    private var placesAdapter: PlacesListTableAdapter!
    private var loader: InterfaceLoader!
    private var refreshControl: UIRefreshControl!


    //MARK: Data & Services
    private let _tag = String.tag(SearchController.self)
    private let guid = Guid.new
    private var displayFlag: DisplayPlacesFlag!
    private var cacheService: SearchPlaceCardsCacheService!
    private var likes: LikesService!
    private var places: [SearchPlaceCard]! {
        didSet {
            placesAdapter.update(places: places)
        }
    }


    //MARK: View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        displayFlag = .all
        cacheService = CacheServices.searchCards
        likes = ServicesFactory.shared.likes

        likes.subscribe(guid: guid, handler: self, tag: _tag)

        setupMarkup()
        loadData(refresh: false)
    }
    deinit {
        likes.unsubscribe(guid: guid)
    }
    private func setupMarkup() {

        loader = InterfaceLoader(for: self.view)
        placesAdapter = PlacesListTableAdapter(source: placesTable, with: self)

        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = ThemeSettings.Colors.background
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        placesTable.addSubview(refreshControl)

        placeTypeSegment.addTarget(self, action: #selector(updateSegment), for: .valueChanged)
        searchbar.delegate = placesAdapter

        navigationController?.setToolbarHidden(true, animated: false)
    }


    //MARK: Load data
    @objc private func refreshData() {
        loadData(refresh: true)
    }
    private func loadData(refresh: Bool) {

        if (!refresh) {
            let cached = cacheService.cache.all
            if (cached.isEmpty) {
                loader.show()
            }

            places = cached
        }


        let task = cacheService.allRemote(with: SelectParameters())
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                if (nil == response) {
                    self.present(ProblemAlerts.NotConnection, animated: false, completion: nil)
                }

                self.completeLoad(with: response ?? [])
            }
        })
    }
    private func completeLoad(with places: [SearchPlaceCard]) {

        self.loader.hide()

        if (refreshControl.isRefreshing){
            refreshControl.endRefreshing()
        }

        self.places = places

        applyUpdates()
    }
    private func applyUpdates() {

        if (displayFlag == .all) {
            placesAdapter.update(places: places)
        }
        else if (displayFlag == .onlyLiked) {
            placesAdapter.update(places: likes.onlyLiked(places))
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

        applyUpdates()
    }
}

//MARK: LikesServiceDelegate
extension SearchController: LikesServiceDelegate {

    public func change(placeId: Long, isLiked: Bool) {
        DispatchQueue.main.async {

            if (self.displayFlag == .onlyLiked) {
                self.applyUpdates()
            }
        }
    }
}
