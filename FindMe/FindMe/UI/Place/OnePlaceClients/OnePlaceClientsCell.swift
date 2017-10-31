//
//  OnePlaceClientsCell.swift
//  FindMe
//
//  Created by Алексей on 31.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceClientsCell: UITableViewCell {

    public static let height = CGFloat(70)
    public static let identifier = Guid.new
    private static let nibName = "OnePlaceClientsCellView"
    public static func register(in tableView: UITableView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }

    //MARK: UI elements
    @IBOutlet private weak var avatarImage: ImageWrapper!
    @IBOutlet private weak var nameLabel: FMSubheadLabel!



    //MARK: Data
    private var _isInitMarkup: Bool = false
    private var _client: PlaceClient?


    public func update(data: PlaceClient) {

        setupMarkup()

        avatarImage.setup(url: data.image)
        nameLabel.text = data.name

        _client = data
    }
    private func setupMarkup() {

        if (_isInitMarkup) {
            return
        }
        _isInitMarkup = true

        avatarImage.layer.cornerRadius = avatarImage.frame.width/2
        avatarImage.layer.borderWidth = 3.0
        avatarImage.layer.borderColor = ThemeSettings.Colors.main.cgColor
    }
}
