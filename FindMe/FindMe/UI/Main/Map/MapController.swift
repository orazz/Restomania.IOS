//
//  MapController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import MapKit
import Gloss

public class MapController: UIViewController {

    //MARK: UI Elements
    @IBOutlet public weak var SegmentControl: UISegmentedControl!
    @IBOutlet public weak var Searchbar: UISearchBar!
    @IBOutlet public weak var MapView: MKMapView!
    private var _popup: MapPopupView!
    private var _loader: InterfaceLoader!


    //MARK: Data & Services
    private var _listAdapter: PlacesListAdapter!
    private var _cache: SearchPlaceCardsCacheService!
    private var _likesService: LikesService!
    private var _positions: PositionsService!

    private var _stored: [SearchAnnotation] = []
    private var _filtered: [SearchAnnotation] = []
    private var _onlyLiked: Bool = false
    private var _filter: ((SearchPlaceCard)->Bool)? = nil


    //MARK: View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _listAdapter = PlacesListAdapter(source: self)

        SegmentControl.addTarget(self, action: #selector(updateSegment), for: .valueChanged)
        Searchbar.delegate = self
        _popup = MapPopupView.build(parent: self.view, delegate: _listAdapter)
        _loader = InterfaceLoader(for: self.view)

        _cache = ServicesFactory.shared.searchCards
        _likesService = ServicesFactory.shared.likes
        _positions = ServicesFactory.shared.positions

        setupMap()
        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    private func setupMap() {

        if (_positions.canUse) {

            MapView.showsUserLocation = true
        }

        if let position = _positions.lastPosition {

            let regionRadius: CLLocationDistance = 2000
            let region = MKCoordinateRegionMakeWithDistance(position.toCoordinates(), regionRadius, regionRadius)

            MapView.setRegion(region, animated: true)
        }

        MapView.isRotateEnabled = false
        MapView.delegate = self
    }

    //MARK: Load data
    private func loadData() {

        let local = _cache.allLocal
        if (local.isEmpty) {
            _loader.show()
        }
        else {

            _stored = local.map({ SearchAnnotation(card: $0) })
            reload()
        }

        let task = _cache.all()
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self._loader.hide()
                self._stored = (response ?? []).map({ SearchAnnotation(card: $0) })
                self.reload()

                if (nil == response) {
                    let alert = UIAlertController(title: "Ошибка", message: "Возникла ошибка при обновлении данных. Проверьте подключение к интернету или повторите позднее.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                    self.navigationController?.show(alert, sender: nil)
                }

            }
        })
    }


    private func reload(filter: @escaping (SearchPlaceCard) -> Bool) {

        _filter = filter
        reload()
    }
    private func reload() {

        let forRemove = MapView.annotations.where({ $0 is SearchAnnotation })
        if (!forRemove.isEmpty){
            MapView.removeAnnotations(forRemove)
        }
        _filtered = _stored

        //Apply filter
        if let filter = _filter {
            _filtered = _filtered.filter({ filter($0.card)  })
        }

        //Filter liked
        if (_onlyLiked) {
            _filtered = _filtered.where({ _likesService.isLiked(place: $0.card.ID) })
        }

        MapView.addAnnotations(_filtered)
    }
}

//MARK: UISearchBarDelegate
extension MapController: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        reload(filter: _listAdapter.filter(for: searchText))
    }
}

//MARK: UISegmentedControl
extension MapController {

    @objc public func updateSegment() {
        switch SegmentControl.selectedSegmentIndex {
            case 1:
                _onlyLiked = true
            
            default:
                _onlyLiked = false
        }

        reload()
    }
}

//MARK: MKMapViewDelegate
extension MapController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if !(annotation is SearchAnnotation) {

            return MKAnnotationView(annotation: annotation, reuseIdentifier: Guid.new)
        }

        let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: SearchAnnotation.requeseIdentifier)
        pin.canShowCallout = false
        pin.image = ThemeSettings.Images.pinActive

        return pin
    }
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let annotation = view.annotation as? SearchAnnotation {

            _popup.update(by: annotation.card)
            _popup.open()
        }
    }

    internal class SearchAnnotation: NSObject,MKAnnotation {

        public static let requeseIdentifier: String = Guid.new

        public var isValidLocation: Bool {

            let location = card.location

            return 0.0 != location.latitude && 0.0 != location.longitude
        }
        //MARK: MKAnnotation
        public var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: card.location.latitude,
                                          longitude: card.location.longitude)
        }
        public var title: String? {
            return card.name
        }
        public var subtitle: String? {
            return card.type
        }

        public let card: SearchPlaceCard

        public init(card: SearchPlaceCard){

            self.card = card

            super.init()
        }
    }
}











