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
    private var delegate: OnePlaceClientsControllerDelegate?


    public override func awakeFromNib() {
        super.awakeFromNib()

        avatarImage.layer.cornerRadius = avatarImage.frame.width/2
        avatarImage.layer.borderWidth = 3.0
        avatarImage.layer.borderColor = ThemeSettings.Colors.main.cgColor

        writeMessageImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(writeMessage))
        writeMessageImage.addGestureRecognizer(tap)
    }
    public func update(by update: PlaceClient, delegate: OnePlaceClientsControllerDelegate) {

        avatarImage.setup(url: update.image)
        nameLabel.text = update.name

        self.client = update
        self.delegate = delegate
    }

    @objc private func writeMessage() {
        if let client = client {
            delegate?.writeMessageTo(client.ID)
        }
    }
}
