//
//  MapController.swift
//  CoreFramework
//
//  Created by Oraz Atakishiyev on 6/20/18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import GoogleMaps

class MapController: UIViewController {
    
    // MARK: UI Elements
    @IBOutlet weak var mapView: FMMap!
    @IBOutlet weak var mapPopUp: MapPopupView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Loaders
    private let service = DependencyResolver.get(PlacesCacheService.self)
    
    private var isOpen: Bool = true
    private var places = [PlaceSummary]()
    
    // MARK: Life circle
    public init() {
        super.init(nibName: String.tag(MapController.self), bundle: Bundle.coreFramework)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    public override func loadView() {
        super.loadView()
        loadMarkers()
    }
    
    func loadMarkers() {
        mapView.delegate = self
        
        if let places = service.all().await().data {
            self.places = places
            
            for pl in places {
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: pl.Location.latitude, longitude: pl.Location.longitude)
                state_marker.title = pl.Name
                state_marker.snippet = "\(pl.Name)"
                state_marker.map = mapView.source
                state_marker.userData = ["id":pl.id]
            }
        }
    }
    
    func show(hide: Bool) {
        let height = hide ? 0 : -mapPopUp.frame.height
        
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction public func closeBtn() {
        show(hide: false)
    }
}

extension MapController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        show(hide: true)
        
        if let dict = marker.userData as? [String:Int] {
            if let id = dict["id"] {
                mapPopUp.setPlaceData(place: places.find(id: Long(id))!)
            }
        }
        return true
    }
    
}
