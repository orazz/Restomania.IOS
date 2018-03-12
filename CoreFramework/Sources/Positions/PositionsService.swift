//
//  PositionsService.swift
//  CoreFramework
//
//  Created by Алексей on 12.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreLocation
import UIKit

public class PositionsService: NSObject {

    public static let shared = PositionsService()


    private var manager: CLLocationManager {

        if (nil == managerInstance) {

            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.distanceFilter = kCLDistanceFilterNone
            manager.pausesLocationUpdatesAutomatically = false
            manager.delegate = self

            managerInstance = manager
        }

        return managerInstance!
    }
    private var managerInstance: CLLocationManager? = nil

    private let _tag = String.tag(PositionsService.self)
    private let events: EventsAdapter<PositionServiceDelegate>

    public private(set) var lastPosition: Position?



    private override init() {

        self.events = EventsAdapter(tag: _tag)
        self.lastPosition = nil

        super.init()
    }



    //MARK: Methods
    public var canUse: Bool {

        if (!isEnable) {
            return false
        }

        switch(CLLocationManager.authorizationStatus()) {

        case .restricted,
             .denied:
            return false

        case .notDetermined,
             .authorizedAlways,
             .authorizedWhenInUse:
            return true
        }
    }
    public var isBlock: Bool {
        return !canUse
    }
    public var isEnable: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    public func distance(to position: Position) -> Double? {

        guard let position = lastPosition else {
            return nil
        }

        let location = position.toLocation()
        return location.distance(from: position.toLocation())
    }



    public func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    public func startTracking() {

        if (isBlock) {
            Log.warning(_tag, "Location service disable. Can't start tracking.")
            return
        }

        manager.startUpdatingLocation()
    }
    public func stopTracking() {

        manager.stopUpdatingLocation()
    }
}
extension PositionsService: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        Log.debug(_tag, "Update location by CLLocationManager.")

        var positions = [Position]()
        for location in locations {

            let age = -location.timestamp.timeIntervalSinceNow
            if (age > 30.0) {
                continue
            }

            let coordinates = location.coordinate
            let accuracy = abs(location.horizontalAccuracy)
            if (accuracy > 2000 ||
                coordinates.latitude == 0.0 ||
                coordinates.longitude == 0.0) {
                continue
            }

            positions.append(Position(from: location))
        }

        lastPosition = positions.first

        if (!positions.isEmpty) {
            events.invoke({ $0.updateLocation(positions: positions) })
        }
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        Log.warning(_tag, "Error with update location: \(error)")
    }
}
extension PositionsService {
    public class Position {

        public let latitude: Double
        public let longtitude: Double
        public let accuracy: Double

        public init(from location: CLLocation) {

            self.latitude = location.coordinate.latitude
            self.longtitude = location.coordinate.longitude
            self.accuracy = location.horizontalAccuracy
        }
        public init(lat: Double, lng: Double) {

            self.latitude = lat
            self.longtitude = lng
            self.accuracy = 1
        }

        public func toCoordinates() -> CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        }
        public func toLocation() -> CLLocation {
            return CLLocation(latitude: latitude, longitude: longtitude)
        }
        public func isCorrelateWith(lat: Double, long: Double, tolerance: Double) -> Bool {

            let left = CLLocation(latitude: latitude, longitude: longtitude)
            let right = CLLocation(latitude: lat, longitude: long)

            let distance = left.distance(from: right)

            return abs(distance) < abs(tolerance)
        }
    }
}
extension PositionsService: IEventsEmitter {
    public typealias THandler = PositionServiceDelegate

    public func subscribe(guid: String, handler: PositionServiceDelegate, tag: String) {
        events.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        events.unsubscribe(guid: guid)
    }
}
extension CLLocationCoordinate2D {
    public static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude == right.latitude && left.longitude == right.longitude
    }
}
