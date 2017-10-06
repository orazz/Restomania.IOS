//
//  PositionService.swift
//  FindMe
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import CoreLocation
import UIKit

public protocol PositionServiceDelegate {

    func updateLocation(position: [PositionsService.Position])
}

public class PositionsService: NSObject, CLLocationManagerDelegate, IEventsEmitter {
    public typealias THandler = PositionServiceDelegate



    private static var _locationManager: CLLocationManager? = nil
    private static let _circlePeriod = 300.0
    private static let _workPeriod = 10.0



    private var _manager :CLLocationManager {

        if (nil == PositionsService._locationManager) {

            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.distanceFilter = kCLDistanceFilterNone
            manager.allowsBackgroundLocationUpdates = true
            manager.pausesLocationUpdatesAutomatically = false

            PositionsService._locationManager = manager
        }

        return PositionsService._locationManager!
    }

    private let _tag = String.tag(PositionsService.self)
    private let _background: BackgroundTaskManager
    private var _backgroundTask: UIBackgroundTaskIdentifier
    private let _eventsAdapter: EventsAdapter<PositionServiceDelegate>
    private var _lastPosition: Position?
    private var _circleTimer: Timer?
    private var _workTimer: Timer?

    public init(background: BackgroundTaskManager) {

        self._background = background
        self._backgroundTask = UIBackgroundTaskInvalid
        self._eventsAdapter = EventsAdapter(name: _tag)
        self._lastPosition = nil

        self._circleTimer = nil
        self._workTimer = nil

        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToBackground),
                                               name: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }
    @objc private func enterToBackground() {

        stopTracking()
//        startTracking()
//
//        if (canUse) {
//            _backgroundTask = _background.beginNew()
//        }
    }

    //MARK: Methods
    public func requestPermission() {

        let manager = _manager
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    public var canUse: Bool {

        if (!CLLocationManager.locationServicesEnabled()) {

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
    public func startTracking() {

        if (isBlock) {

            Log.Warning(_tag, "Location service disable. Can't start tracking.")
            return
        }

        let manager = _manager
        manager.delegate = self

        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    public func stopTracking() {

        if let timer = _circleTimer {

            timer.invalidate()
            _circleTimer = nil
        }

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

        Log.Debug(_tag, "Update location by CLLocationManager.")

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

            _eventsAdapter.Trigger(action: { $0.updateLocation(position: positions) })
        }





        //Start proces background mode
        let application = UIApplication.shared
        if (application.applicationState != .background) {
            return
        }

        //Restart updates
        if (nil != _circleTimer) {
            return
        }

        //Process full work circle
        _backgroundTask = _background.beginNew()
        _circleTimer = Timer(timeInterval: PositionsService._circlePeriod,
                             target: self,
                             selector: #selector(restartUpdates),
                             userInfo: nil,
                             repeats: false)


        //Process work timer
        if let timer = _workTimer {

            timer.invalidate()
            _workTimer = nil
        }
        _workTimer = Timer(timeInterval: PositionsService._workPeriod,
                           target: self,
                           selector: #selector(stopWork),
                           userInfo: nil,
                           repeats: false)
    }
    @objc private func restartUpdates() {

        Log.Debug(_tag, "Restart location updates.")

        if let timer = _circleTimer {

            timer.invalidate()
            _circleTimer = nil
        }

        startTracking()
    }
    @objc private func stopWork() {

        Log.Debug(_tag, "Go to sleep updates of location.")

        _manager.stopUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        Log.Warning(_tag, "Error with update location: \(error)")
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
    }
}
