//
//  ChatDialogCell.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ChatDialogsDialogRow: UITableViewCell {

    public static let height = CGFloat(60.0)
    public static let identifier = "\(String.tag(ChatDialogsDialogRow.self))-\(Guid.new)"
    private static let nibName = "\(String.tag(ChatDialogsDialogRow.self))View"
    public static func register(in table: UITableView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var logoImage: ImageWrapper!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastMessageLabel: UILabel!

    //Data
    private var dialog: ChatDialog?


    public override func awakeFromNib() {
        super.awakeFromNib()

        logoImage.layer.cornerRadius = logoImage.frame.width/2
        logoImage.layer.borderWidth = 3.0
        logoImage.layer.borderColor = ThemeSettings.Colors.main.cgColor

        nameLabel.font = ThemeSettings.Fonts.bold(size: .subhead)
        nameLabel.textColor = ThemeSettings.Colors.blackText

        lastMessageLabel.font = ThemeSettings.Fonts.default(size: .caption)
        lastMessageLabel.textColor = ThemeSettings.Colors.blackText
    }
    public override func prepareForReuse() {
        super.prepareForReuse()

        logoImage.clear()
    }
    public func update(by update: ChatDialog) {

        self.dialog = update

        logoImage.setup(url: update.logo)
        nameLabel.text = update.name
        lastMessageLabel.text = update.lastMessage?.content ?? String.empty
    }
}
