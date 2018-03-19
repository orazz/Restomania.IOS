//
//  OneOrderCommentContainer.swift
//  CoreFramework
//
//  Created by Алексей on 16.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OneOrderCommentContainer: UITableViewCell {

    public static var instance: OneOrderCommentContainer {
        return UINib.instantiate(from: String.tag(OneOrderCommentContainer.self), bundle: Bundle.coreFramework)
    }

    //UI
    @IBOutlet private weak var commentLabel: UILabel!

    //Theme
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        commentLabel.text = String.empty
        commentLabel.font = themeFonts.default(size: .caption)
        commentLabel.textColor = themeColors.contentText
    }
}
extension OneOrderCommentContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {
        
        commentLabel.text = update.summary.comment
    }
}
extension OneOrderCommentContainer: InterfaceTableCellProtocol {
    public var viewHeight: Int {

        if (String.isNullOrEmpty(commentLabel.text)) {
            return 0
        }

        let comment = commentLabel.text!
        let padding = 10
        return 2 * padding + Int(comment.height(containerWidth: commentLabel.frame.width, font: commentLabel.font!))
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
