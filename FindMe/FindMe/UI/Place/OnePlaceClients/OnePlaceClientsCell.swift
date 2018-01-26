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
    @IBOutlet private weak var writeMessageImage: UIImageView!

    //MARK: Data
    private var client: PlaceClient?
    public var userId: Long {
        return client?.ID ?? 0
    }


    public override func awakeFromNib() {
        super.awakeFromNib()

        avatarImage.layer.cornerRadius = avatarImage.frame.width/2
        avatarImage.layer.borderWidth = 3.0
        avatarImage.layer.borderColor = ThemeSettings.Colors.main.cgColor
    }
    public func update(by update: PlaceClient) {

        avatarImage.setup(url: update.image)
        nameLabel.text = update.name

        self.client = update
    }
}
