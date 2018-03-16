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

public class OtherNotificationControllerTitle: UIView {

    //UI
    @IBOutlet private weak var titleLabel: UILabel!

    //Service
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    private var title: Localizable? {
        didSet {
            titleLabel?.text = title?.localized ?? String.empty
        }
    }

    internal static func create(with title: Localizable) -> OtherNotificationControllerTitle {
        let header: OtherNotificationControllerTitle = UINib.instantiate(from: String.tag(OtherNotificationControllerTitle.self), bundle: Bundle.coreFramework)
        header.title = title

        return header
    }


    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentDivider

        titleLabel.font = themeFonts.default(size: .caption)
        titleLabel.textColor = themeColors.contentDividerText
    }
}
