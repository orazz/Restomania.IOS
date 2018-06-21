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
    
    private let service = DependencyResolver.get(PlacesCacheService.self)
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func loadMarkers() {
        
        mapView.delegate = self
        
        if let places = service.all().await().data {
            for pl in places {
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: pl.Location.latitude, longitude: pl.Location.longitude)
                state_marker.title = pl.Name
                state_marker.snippet = "\(pl.Name)"
                state_marker.map = mapView.source
            }
        }
    }
    
}

extension MapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("test")
        return true
    }
}
