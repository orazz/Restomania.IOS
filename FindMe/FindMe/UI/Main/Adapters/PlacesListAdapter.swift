//
//  PlacesListAdapter.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public protocol PlacesListDelegate {

    func goTo(place: Long)

    func isLiked(place: Long) -> Bool
    func like(place: Long)
    func unlike(place: Long)

    func distanceTo(position: PositionsService.Position) -> Double?

    func filter(_ range: [SearchPlaceCard], by phrase: String) -> [SearchPlaceCard]
}
public class PlacesListAdapter: PlacesListDelegate {

    private let _navigationContrller: UINavigationController
    private let _positions: PositionsService
    private let _likes: LikesService
    private let _searchAdapter: SearchAdapter<SearchPlaceCard>

    public init(source: UIViewController){

        self._navigationContrller = source.navigationController!

        let services = ServicesFactory.shared
        self._positions = services.positions
        self._likes = services.likes

        self._searchAdapter = SearchAdapter()
        _searchAdapter.add({ $0.name })
        _searchAdapter.add({ $0.type })
        _searchAdapter.add({ $0.description })
        _searchAdapter.add({ $0.location.address })
        _searchAdapter.add({ $0.location.city })
        _searchAdapter.add({ $0.location.metro })
        _searchAdapter.add({ $0.location.borough })
    }


    //MARK: PlacesListDelegate
    public func goTo(place: Long) {

        let controller = OnePlaceMainController.build(placeId: place)

        self._navigationContrller.pushViewController(controller, animated: true)
    }

    public func isLiked(place: Long) -> Bool {
        return _likes.isLiked(place: place)
    }
    public func like(place: Long) {
        _likes.like(place: place)
    }
    public func unlike(place: Long) {
        _likes.unlike(place: place)
    }

    public func distanceTo(position: PositionsService.Position) -> Double? {
        return _positions.distance(to: position)
    }

    public func filter(_ range: [SearchPlaceCard], by phrase: String) -> [SearchPlaceCard] {
        return _searchAdapter.filter(phrase: phrase, for: range)
    }
    public func filter(for phrase: String) -> ((SearchPlaceCard)->Bool) {

        return { card  in
            return self._searchAdapter.search(phrase: phrase, in: card)
        }
    }
}
