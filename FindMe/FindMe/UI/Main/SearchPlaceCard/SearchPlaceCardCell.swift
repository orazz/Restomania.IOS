//
//  SearchPlaceCardCell.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class SearchPlaceCardCell: UITableViewCell {

    //MARK: Cell properties
    public static let identifier = Guid.new
    private static let nibName = "SearchPlaceCardView"
    public static let height = CGFloat(110)

    public static func register(in tableview: UITableView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        tableview.register(nib, forCellReuseIdentifier: identifier)
    }

    //MARK: UIElements
    @IBOutlet public weak var PlaceImage: ImageWrapper!
    @IBOutlet public weak var PlaceNameLabel: FMHeadlineLabel!
    @IBOutlet public weak var PlaceDescriptionLabel: FMCaptionLabel!
    @IBOutlet public weak var PlacePeopleCountLabel: FMSubstringLabel!
    @IBOutlet public weak var DistanceToPlaceImage: UIImageView!
    @IBOutlet public weak var DistanceToPlaceLabel: FMSubstringLabel!
    @IBOutlet public weak var LikeImage: UIImageView!

    

    //MARK: Data
    private var _source: SearchPlaceCard!
    private var _isLiked: Bool = false
    private var _delegate: PlacesListDelegate!
    private var _isSetupMarkup: Bool = false



    //MARK: Constructors



    public func setup(card: SearchPlaceCard, delegate: PlacesListDelegate) {

        setupMarkup()
        _source = card
        _delegate = delegate

        PlaceImage.setup(url: card.image)
        PlaceNameLabel.text = card.name
        PlaceDescriptionLabel.text = card.description
        PlacePeopleCountLabel.text = "\(card.peopleCount)"

        setupDistance()
        setupLike()
    }

    private func setupMarkup() {

        if (_isSetupMarkup){
            return
        }
        _isSetupMarkup = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnLike))
        LikeImage.addGestureRecognizer(tap)
    }
    private func setupDistance() {

        var isHidden = true
        if (0.0 != _source.location.latitude && 0.0 != _source.location.longitude) {

            let position = PositionsService.Position(lat: _source.location.latitude, lng: _source.location.longitude)
            if let distance = _delegate.distanceTo(position: position) {

                DistanceToPlaceLabel.text = formatDistance(distance)
                isHidden = false
            }
        }

        DistanceToPlaceLabel.isHidden = isHidden
        DistanceToPlaceImage.isHidden = isHidden
    }
    private func formatDistance(_ distance: Double) -> String{

        if (distance < 1000) {

            return "\(Int(distance)) m"
        }
        else {

            let formated = Int(floor(distance / 100))
            return "\(formated/10) km"
        }
    }



    //MARK: Likes
    private func setupLike() {

        let isLiked = _delegate.isLiked(place: _source.ID)

        setupLike(isLiked)

        _isLiked = isLiked
    }
    private func setupLike(_ isLiked: Bool) {

        if (isLiked) {
            LikeImage.image = ThemeSettings.Images.heartActive
        }
        else {
            LikeImage.image = ThemeSettings.Images.heartInactive
        }
    }
    @objc private func tapOnLike() {

        _isLiked = !_isLiked
        setupLike(_isLiked)

        if (_isLiked) {
            _delegate.like(place: _source.ID)
        }
        else {
            _delegate.unlike(place: _source.ID)
        }

    }
}
