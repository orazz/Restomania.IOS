//
//  OneOrderTitleSection.swift
//  CoreFramework
//
//  Created by Алексей on 16.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OneOrderTitleSection: UITableViewCell {

    public static func create(title: Localizable? = nil, about content: InterfaceTableCellProtocol? = nil) -> OneOrderTitleSection {

        let cell: OneOrderTitleSection =  UINib.instantiate(from: String.tag(OneOrderTitleSection.self), bundle: Bundle.coreFramework)
        cell.title = title
        cell.content = content

        return cell
    }

    //UI
    @IBOutlet private weak var titleLabel: UILabel!

    //Theme
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var title: Localizable? = nil {
        didSet {
            titleLabel.text = title?.localized ?? String.empty
        }
    }
    private var content: InterfaceTableCellProtocol? = nil

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.divider

        titleLabel.text = String.empty
        titleLabel.font = themeFonts.default(size: .caption)
        titleLabel.textColor = themeColors.dividerText
    }
}
extension OneOrderTitleSection: OneOrderInterfacePart {
    public func update(by update: DishOrder) {}
}
extension OneOrderTitleSection: InterfaceTableCellProtocol {
    public var viewHeight: Int {

        if let content = content,
            content.viewHeight == 0 {
            return 0
        }

        return 40
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
