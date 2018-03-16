//
//  DishModalSelectHeader.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectHeader: UITableViewCell {

    public static func create(with title: String) -> DishModalSelectHeader {

        let cell: DishModalSelectHeader = UINib.instantiate(from: "\(String.tag(DishModalSelectHeader.self))View", bundle: Bundle.coreFramework)
        cell.title = title

        return cell
    }

    //UI
    @IBOutlet private weak var titleLabel: UILabel!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = themeColors.contentBackground

        titleLabel.font = themeFonts.bold(size: .head)
        titleLabel.textColor = themeColors.contentText
        titleLabel.backgroundColor = themeColors.contentBackground
    }
}
extension DishModalSelectHeader: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return Int(title?.height(containerWidth: titleLabel.frame.width, font: titleLabel.font) ?? 0) + 20
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
