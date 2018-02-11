//
//  PositionService.swift
//  FindMe
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreLocation
import UIKit

public protocol PositionServiceDelegate {

    func updateLocation(positions: [PositionsService.Position])
}

public class PositionsService: NSObject, CLLocationManagerDelegate, IEventsEmitter {
    public typealias THandler = PositionServiceDelegate

    private var _locationManager: CLLocationManager? = nil
    private var _manager: CLLocationManager {

        if (nil == _locationManager) {

            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.distanceFilter = kCLDistanceFilterNone
            manager.allowsBackgroundLocationUpdates = true
            manager.pausesLocationUpdatesAutomatically = false
            manager.delegate = self

            _locationManager = manager
        }

        return _locationManager!
    }

    private let _tag = String.tag(PositionsService.self)
    private let _application = UIApplication.shared
    private let _eventsAdapter: EventsAdapter<PositionServiceDelegate>
    private var _lastPosition: Position?

    public override init() {

        self._eventsAdapter = EventsAdapter(tag: _tag)
        self._lastPosition = nil


        super.init()
    }

    //MARK: Methods
    public func requestPermission(always: Bool = false) {

        let manager = _manager

        if (always) {
            manager.requestAlwaysAuthorization()
        }
        else {
            manager.requestWhenInUseAuthorization()
        }
    }
    public var isEnable: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    public var canUse: Bool {

        if (!isEnable) {
            return false
        }

        switch(CLLocationManager.authorizationStatus()) {

            case .notDetermined,
                 .restricted,
                 .denied:
                return false

            case .authorizedAlways,
                 .authorizedWhenInUse:
                return true
        }
    }
    public var canUseInBackground: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    public var isBlock: Bool {
        return !canUse
    }
    public var lastPosition: Position? {
        return _lastPosition
    }
    public func distance(to position: Position) -> Double? {

        if (isBlock || nil == _lastPosition) {
            return nil
        }

        let location = _lastPosition!.toLocation()
        return location.distance(from: position.toLocation())
    }



    //MARK: Tracking
    public func startTracking(always: Bool = false) {

        if (isBlock) {

            Log.warning(_tag, "Location service disable. Can't start tracking.")
            return
        }

        let manager = _manager

        if (always) {
            manager.requestAlwaysAuthorization()
        }
        else {
            manager.requestWhenInUseAuthorization()
        }

        manager.startUpdatingLocation()
    }
    public func stopTracking() {

        _manager.stopUpdatingLocation()
    }



    //MARK: IEventEmitter
    public func subscribe(guid: String, handler: PositionServiceDelegate, tag: String) {
        _eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        _eventsAdapter.unsubscribe(guid: guid)
    }



    //MARK: CLLocationManagerDelegate
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

        _lastPosition = positions.first

        if (!positions.isEmpty) {
            _eventsAdapter.invoke({ $0.updateLocation(positions: positions) })
        }
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        Log.warning(_tag, "Error with update location: \(error)")
    }



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
extension CLLocationCoordinate2D {

    public static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {

        return left.latitude == right.latitude && left.longitude == right.longitude
    }
}


//    //Send the location to Server
//    - (void)updateLocationToServer {
//
//    NSLog(@"updateLocationToServer");
//
//    // Find the best location from the array based on accuracy
//    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
//
//    for(int i=0;i<self.shareModel.myLocationArray.count;i++){
//    NSMutableDictionary * currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
//
//    if(i==0)
//    myBestLocation = currentLocation;
//    else{
//    if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue]){
//    myBestLocation = currentLocation;
//    }
//    }
//    }
//    NSLog(@"My Best location:%@",myBestLocation);
//
//    //If the array is 0, get the last location
//    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
//    if(self.shareModel.myLocationArray.count==0)
//    {
//    NSLog(@"Unable to get location, use the last known location");
//
//    self.myLocation=self.myLastLocation;
//    self.myLocationAccuracy=self.myLastLocationAccuracy;
//
//    }else{
//    CLLocationCoordinate2D theBestLocation;
//    theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
//    theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
//    self.myLocation=theBestLocation;
//    self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
//    }
//
//    NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
//
//    //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
//
//    //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
//    [self.shareModel.myLocationArray removeAllObjects];
//    self.shareModel.myLocationArray = nil;
//    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
//    }
