//
//  OnePlaceLocationController.swift
//  FindMe
//
//  Created by Алексей on 31.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import MapKit

public class OnePlaceLocationController: UIViewController {

    private static let nibName = "OnePlaceLocationView"
    public static func instance(place: Place) -> OnePlaceLocationController {

        let instance = OnePlaceLocationController(nibName: nibName, bundle: Bundle.main)

        instance._place = place

        return instance
    }



    //MARK: UI elements
    @IBOutlet public weak var mapView: FMMap!



    //MARK: Data & services
    private let _tag = String.tag(OnePlaceLocationController.self)
    private var _place: Place!



    //MARK: View circle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mapView.showsControls = true

        let pin = MapController.SearchAnnotation(place: _place)
        mapView.addAnnotation(pin)
        mapView.setCenter(pin.coordinate, animated: false)
        mapView.selectAnnotation(pin, animated: true)
        mapView.zoom(multiplier: 1/18000)
    }



    //MARK: Actions
    @IBAction public func close() {

        navigationController?.popViewController(animated: true)
    }
}

//MARK: MKMapViewDelegate
extension OnePlaceLocationController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if let annotation = annotation as? MapController.SearchAnnotation {

            let pin = annotation.buildView()
            pin.canShowCallout = true
            pin.image = ThemeSettings.Images.pinLarge

            return pin
        }
        else {
            return MKAnnotationView(annotation: annotation, reuseIdentifier: Guid.new)
        }
    }
}
