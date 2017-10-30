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
    @IBOutlet public weak var MapView: FMMap!
    private var _popup: MapPopupView!
    private var _loader: InterfaceLoader!


    //MARK: Data & Services
    private var _listAdapter: PlacesListAdapter!
    private var _cache: SearchPlaceCardsCacheService!
    private var _likesService: LikesService!
    private var _positions: PositionsService!

    private var _places: [SearchPlaceCard]! {
        didSet {
            _stored = _places.map({ SearchAnnotation(card: $0) })
        }
    }
    private var _stored: [SearchAnnotation]! {
        didSet {
            reload()
        }
    }
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

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupMap()
    }
    private func setupMap() {

        MapView.showsControls = true
    }

    //MARK: Load data
    private func loadData() {

        let local = _cache.allLocal
        if (local.isEmpty) {
            _loader.show()

            _places = []
        }
        else {

            _places = local
        }

        let task = _cache.all()
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self._loader.hide()

                if let response = response {

                    self._places = response
                }
                else if (self._places.isEmpty) {

                    let alert = UIAlertController(title: "Ошибка", message: "Возникла ошибка при обновлении данных. Проверьте подключение к интернету или повторите позднее.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: false, completion: nil)
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

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        _popup.close()
    }
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        reload(filter: _listAdapter.filter(for: searchText))
        _popup.close()
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        _popup.close()
    }
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        _popup.close()
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

        _popup.close()
        reload()
    }
}

//MARK: MKMapViewDelegate
extension MapController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if let annotation = annotation as? SearchAnnotation {

            let pin = annotation.buildView()
            pin.canShowCallout = false
            pin.image = ThemeSettings.Images.pinLarge

            return pin
        }
        else {
            return MKAnnotationView(annotation: annotation, reuseIdentifier: Guid.new)
        }
    }
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let annotation = view.annotation as? SearchAnnotation {

            Searchbar.endEditing(true)

            _popup.update(by: annotation.card)
            _popup.open()
        }
    }

    internal class SearchAnnotation: NSObject, MKAnnotation {

        public static let requeseIdentifier: String = Guid.new
        public let card: SearchPlaceCard

        public init(card: SearchPlaceCard){

            self.card = card

            super.init()
        }
        public convenience init(place: Place) {
            self.init(card: SearchPlaceCard(source: place))
        }


        public var isValidLocation: Bool {

            let location = card.location

            return 0.0 != location.latitude && 0.0 != location.longitude
        }
        public func buildView() -> MKAnnotationView {

            return MKAnnotationView(annotation: self, reuseIdentifier: SearchAnnotation.requeseIdentifier)
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
    }
}











