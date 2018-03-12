//
//  DistanceLabel.swift
//  CoreFramework
//
//  Created by Алексей on 13.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DistanceLabel: UIView {

    public static let height: CGFloat = 20.0
    public static let width: CGFloat = 70.0

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var distanceLabel: UILabel!

    public private(set) var distance: Double? = nil
    public private(set) var position: PositionsService.Position? = nil

    private let _tag = String.tag(DistanceLabel.self)
    private let guid = Guid.new

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)
    private let themeImages = DependencyResolver.resolve(ThemeImages.self)

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)!

        initialize()
    }
    private func initialize() {

        connect()

        PositionsService.shared.subscribe(guid: guid, handler: self, tag: _tag)
    }
    private func connect() {

        Bundle.coreFramework.loadNibNamed(String.tag(DistanceLabel.self), owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.setContraint(height: DistanceLabel.height)
        contentView.setContraint(width: DistanceLabel.width)
    }
    public override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = themeColors.contentBackground

        iconImage.image = themeImages.iconNavigation.tint(color: themeColors.contentBackgroundText)
        iconImage.isHidden = true

        distanceLabel.font = themeFonts.default(size: .caption)
        distanceLabel.textColor = themeColors.contentBackgroundText
        distanceLabel.text = String.empty

        if let _ = self.getConstant(.height) {
            self.setContraint(.height, to: DistanceLabel.height)
        }
        if let _ = self.getConstant(.width) {
            self.setContraint(.width, to: DistanceLabel.width)
        }
    }

    public func setup(lat: Double, lng: Double) {
        setup(position: PositionsService.Position(lat: lat, lng: lng))
    }
    public func setup(position: PositionsService.Position) {

        if (position.isEmpty) {
            self.position = nil
        }
        else {
            self.position = position
        }

        DispatchQueue.main.async {
            self.refresh()
        }
    }
    public func refresh() {

        guard let position = self.position,
                let distance = PositionsService.shared.distance(to: position) else {

                self.distance = nil
                self.iconImage.isHidden = true
                clear()
                return
        }

        self.distance = distance
        self.iconImage.isHidden = false
        self.distanceLabel.text = buildFormattedDistance(for: distance)
    }
    private func buildFormattedDistance(for distance: Double) -> String {

        let distance = abs(distance)

        if distance > 100.0 {
            let rest = Int(floor(distance / 100.0))
            return "\(rest / 10).\(rest % 10) \(Localization.unitsKm.localized)"
        }
        else {
            let rest = Int(floor(distance))
            return "\(rest) \(Localization.unitsM.localized)"
        }
    }
    public func clear() {

        self.position = nil
        self.distance = nil
        self.distanceLabel.text = String.empty
    }
}
extension DistanceLabel: PositionServiceDelegate {
    
    public func positionsService(_ service: PositionsService, update position: PositionsService.Position) {
        DispatchQueue.main.async {
            self.refresh()
        }
    }
}
extension DistanceLabel {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(DistanceLabel.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case unitsKm = "Units.Km"
        case unitsM = "Units.M"
    }
}
