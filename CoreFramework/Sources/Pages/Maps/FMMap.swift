//
//  FMMap.swift
//  CoreFramework
//
//  Created by Oraz Atakishiyev on 6/20/18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import GoogleMaps

public class FMMap: UIView {
    //
    //    public var zoomMultiplier: Double = 3
    //    private let defaultDelta: Double = 0.04
    private let zoomDelta: Float = 1.0
    private let zoomConvertK: Double = 5.51724138
    
    //Services
    private let themeImages = DependencyResolver.get(ThemeImages.self)
    
    //UI
    private var plusControl: Control!
    private var minusControl: Control!
    private var navigationControl: Control!
    
    public private(set) var source: GMSMapView!
    public var showsControls: Bool {
        get {
            return nil != plusControl.superview
        }
        set {
            if (newValue) {
                self.addSubview(plusControl)
                self.addSubview(minusControl)
                self.addSubview(navigationControl)
            }
            else {
                plusControl.removeFromSuperview()
                minusControl.removeFromSuperview()
                navigationControl.removeFromSuperview()
            }
        }
    }
    public var showUserLocation: Bool {
        get {
            return source.isMyLocationEnabled
        }
        set {
            source.isMyLocationEnabled = newValue
        }
    }
    
    public var delegate: GMSMapViewDelegate? {
        get {
            return source.delegate
        }
        set {
            source.delegate = newValue
        }
    }
    public var horizontalMetresDelta: Double {
        return Double(Float(frame.width) * source.camera.zoom) / zoomConvertK
    }
    public var verticalMetresDelta: Double {
        return Double(Float(frame.height) * source.camera.zoom) / zoomConvertK
    }
    public var cameraMetresDelta: Double {
        let v = verticalMetresDelta
        let h = horizontalMetresDelta
        return sqrt(v*v + h*h)
    }
    
    
    //Data
    private let _tag = String.tag(FMMap.self)
    private let guid = Guid.new
    //private var positions = LogicServices.shared.positions
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    deinit {
        //positions.unsubscribe(guid: guid)
    }
    
    private func setup() {
        
        //positions.subscribe(guid: guid, handler: self, tag: _tag)
        
        loadElements()
        setupStyles()
        setupPosition()
    }
    private func loadElements() {
        
        plusControl = Control(image: themeImages.iconPlus, selector: #selector(zoomIn), target: self)
        plusControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(plusControl)
        
        minusControl = Control(image: themeImages.iconMinus, selector: #selector(zoomOut), target: self)
        minusControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(minusControl)
        
        navigationControl = Control(image: themeImages.iconNavigation, selector: #selector(toCurrentPosition), target: self)
        navigationControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(navigationControl)
        
        
        source = GMSMapView(frame: CGRect.zero)
        source.translatesAutoresizingMaskIntoConstraints = false
        addSubview(source)
        
        
        
        NSLayoutConstraint.activate([
            //plus
            NSLayoutConstraint(item: plusControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Control.size),
            NSLayoutConstraint(item: plusControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Control.size),
            NSLayoutConstraint(item: plusControl, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -Control.size/2 - 5.0),
            NSLayoutConstraint(item: plusControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10),
            //minus
            NSLayoutConstraint(item: minusControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Control.size),
            NSLayoutConstraint(item: minusControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Control.size),
            NSLayoutConstraint(item: minusControl, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: Control.size/2 + 5.0),
            NSLayoutConstraint(item: minusControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10),
            //navigation
            NSLayoutConstraint(item: navigationControl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Control.size),
            NSLayoutConstraint(item: navigationControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Control.size),
            NSLayoutConstraint(item: navigationControl, attribute: .top, relatedBy: .equal, toItem: minusControl, attribute: .bottom, multiplier: 1, constant: 30.0),
            NSLayoutConstraint(item: navigationControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10),
            //map
            NSLayoutConstraint(item: source, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: source, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: source, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: source, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
    }
    private func setupStyles() {
        
        showsControls = true
        showUserLocation = true
    }
    private func setupPosition() {
        
        let defaultCenter = CLLocationCoordinate2D(latitude: 50.0084, longitude: 82.9357)
        center(to: defaultCenter, animate: false)

        self.toCurrentPosition()
        
        zoom(multiplier: 15)
    }
    
    //MARK: Controls
    @objc public func zoomIn() {
        zoom(multiplier: source.camera.zoom + zoomDelta)
    }
    @objc public func zoomOut() {
        zoom(multiplier: source.camera.zoom - zoomDelta)
    }
    public func zoom(multiplier: Float) {
        
        source.animate(toZoom: multiplier)
    }
    @objc public func toCurrentPosition() {
        
        NCLocationManager.shared.getCurrentLocation { (manager, location) in
            if let current = location {
                self.center(to: current.coordinate)
            }
        }
    }
    public func center(to position: CLLocationCoordinate2D, animate: Bool = true) {
        
        let update = GMSCameraUpdate.setTarget(position)
        
        if (animate) {
            source.animate(with: update)
        }
        else {
            source.moveCamera(update)
        }
    }
    
    //Markers
    public func add(markers: [GMSMarker]) {
        
        for marker in markers {
            marker.map = source
        }
    }
    public func remove(markers: [GMSMarker]) {
        
        for marker in markers {
            marker.map = nil
        }
    }
}
extension FMMap: PositionServiceDelegate { }
extension FMMap {
    
    fileprivate class Control: UIView {
        
        fileprivate static let size = CGFloat(45)
        
        fileprivate required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        fileprivate init(image: UIImage, selector: Selector, target: Any) {
            
            super.init(frame: CGRect(x: 0, y: 0, width: Control.size, height: Control.size))
            
            let imageView = UIImageView(image: image)
            let side = CGFloat(20)
            let offset = (Control.size - side)/2
            imageView.frame = CGRect(x: offset, y: offset, width: side, height: side)
            self.addSubview(imageView)
            
            let tap = UITapGestureRecognizer(target: target, action: selector)
            self.addGestureRecognizer(tap)
            
            self.layer.cornerRadius = 0.5 * Control.size
            self.clipsToBounds = true
            self.backgroundColor = DependencyResolver.get(ThemeColors.self).contentBackground
        }
    }
}
