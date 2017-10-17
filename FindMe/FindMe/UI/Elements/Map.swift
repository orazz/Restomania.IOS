//
//  FMMap.swift
//  FindMe
//
//  Created by Алексей on 17.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import IOSLibrary

public class FMMap: MKMapView {

    public var zoomMultiplier: Double = 3
    public var showsControls: Bool! {
        didSet {
            updateControls()
        }
    }
    private let defaultDelta: Double = 0.04

    //MARK: Services
    private let _tag = String.tag(FMMap.self)
    private let _guid = Guid.new
    private var _positions: PositionsService!

    //MARK: Elements
    private var _plus: Control!
    private var _minus: Control!
    private var _navigation: Control!

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    deinit {
        _positions.unsubscribe(guid: _guid)
    }

    private func setup() {

        _positions = ServicesFactory.shared.positions
        _positions.subscribe(guid: _guid, handler: self, tag: _tag)

        setupStyles()
        setupPosition()
    }
    private func setupStyles() {

        _plus = Control(image: ThemeSettings.Images.plus, selector: #selector(zoomIn), target: self)
        _minus = Control(image: ThemeSettings.Images.minus, selector: #selector(zoomOut), target: self)
        _navigation = Control(image: ThemeSettings.Images.navigation, selector: #selector(toCurrentPosition), target: self)

        showsControls = false
        isRotateEnabled = false
    }
    private func setupPosition() {

        showsUserLocation = true

        if _positions.canUse {

            let span = MKCoordinateSpan(latitudeDelta: defaultDelta, longitudeDelta: defaultDelta)
            let center = CLLocationCoordinate2D(latitude: 50.0084, longitude: 82.9357)
            let region = MKCoordinateRegion(center: center, span: span)
            self.setRegion(region, animated: false)

            toCurrentPosition()
        }
    }

    private func updateControls() {

        if (showsControls) {

            let parentFrame = self.frame
            let x = parentFrame.width - CGFloat(10) - Control.size
            let y = (parentFrame.height - Control.size)/2 + CGFloat(50)

            updateXY(x: x, y: y, to: _navigation)
            updateXY(x: x, y: y - CGFloat(50) - Control.size, to: _minus)
            updateXY(x: x, y: _minus.frame.origin.y - CGFloat(10) - Control.size, to: _plus)

            self.addSubview(_plus)
            self.addSubview(_minus)
            self.addSubview(_navigation)
        }
        else {

            _plus.removeFromSuperview()
            _minus.removeFromSuperview()
            _navigation.removeFromSuperview()
        }
    }
    private func updateXY(x: CGFloat, y: CGFloat, to view: UIView) {

        let frame = view.frame
        view.frame = CGRect(x: x, y: y, width: frame.width, height: frame.height)
    }

    //MARK: Controls
    @objc public func zoomIn() {
        zoom(multiplier: 1/zoomMultiplier)
    }
    @objc public func zoomOut() {
        zoom(multiplier: zoomMultiplier)
    }
    public func zoom(multiplier: Double) {

        let region = self.region
        let span = region.span

        let newSpan = MKCoordinateSpan(latitudeDelta: span.latitudeDelta * multiplier, longitudeDelta: span.longitudeDelta * multiplier)
        let newRegion = MKCoordinateRegionMake(region.center, newSpan)

        self.setRegion(newRegion, animated: true)
    }
    @objc public func toCurrentPosition() {

        guard _positions.canUse,
              let coordinates = _positions.lastPosition else {
            return
        }

        let region = self.region
        let newCenter = coordinates.toCoordinates()
        let newRegion = MKCoordinateRegion(center: newCenter, span: region.span)
        self.setRegion(newRegion, animated: true)
    }
}
extension FMMap: PositionServiceDelegate {

    public func updateLocation(position: [PositionsService.Position]) {

    }
}

extension FMMap {

    private class Control: UIView {

        public static let size = CGFloat(45)

        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        public init(image: UIImage, selector: Selector, target: Any) {

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
            self.backgroundColor = ThemeSettings.Colors.background
        }
    }
}
