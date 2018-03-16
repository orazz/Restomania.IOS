//
//  OtherNotificationControllerTitle.swift
//  CoreFramework
//
//  Created by Алексей on 16.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OtherNotificationControllerTitle: UITableViewCell {

    public static let identifier = Guid.new
    public static func register(in table: UITableView) {
        let nib = UINib(nibName: String.tag(OtherNotificationControllerTitle.self), bundle: Bundle.coreFramework)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var titleLabel: UILabel!

    //Service
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentDivider

        titleLabel.font = themeFonts.default(size: .caption)
        titleLabel.textColor = themeColors.contentDividerText
    }

    open func setup(title: Localizable) {
        titleLabel.text = title.localized
    }
}
