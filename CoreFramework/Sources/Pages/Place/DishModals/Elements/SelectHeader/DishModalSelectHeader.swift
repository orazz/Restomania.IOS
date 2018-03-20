//
//  DishModalSelectHeader.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectHeader: UITableViewCell {

    public static func create(with title: String) -> DishModalSelectHeader {

        let nibname = String.tag(DishModalSelectHeader.self)
        let cell: DishModalSelectHeader = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.title = title

        return cell
    }

    //UI
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var topOffset: NSLayoutConstraint!
    @IBOutlet private weak var bottomOffset: NSLayoutConstraint!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = themeColors.divider

        titleLabel.font = themeFonts.default(size: .subhead)
        titleLabel.textColor = themeColors.dividerText
    }
}
extension DishModalSelectHeader: InterfaceTableCellProtocol {

    public var viewHeight: Int {

        let text = titleLabel.text ?? String.empty
        let width = titleLabel.frame.width
        let height = text.height(containerWidth: width, font: titleLabel.font)
        return Int(height + topOffset.constant + bottomOffset.constant)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
