//
//  PlaceMenuSubcategoryHeader.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 17.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceMenuSubcategoryHeader: UITableViewCell {

    public static let identifier = "\(String.tag(PlaceMenuSubcategoryHeader.self))-\(Guid.new)"
    public static let height = CGFloat(35)

    private static let nibName = "\(String.tag(PlaceMenuSubcategoryHeader.self))View"
    private static let nib = UINib(nibName: nibName, bundle: Bundle.main)
    public static func instance(for title: String) -> PlaceMenuSubcategoryHeader {

        let cell = nib.instantiate(withOwner: nil, options: nil).first as! PlaceMenuSubcategoryHeader

        cell.title = title

        return cell
    }

    //UI
    @IBOutlet private var titleLabel: UILabel!

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

        backgroundColor = themeColors.contentBackground

        titleLabel.textColor = themeColors.contentBackgroundText
        titleLabel.font = themeFonts.bold(size: .head)

        title = String.empty
    }
}
