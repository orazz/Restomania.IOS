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
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentDivider

        commentLabel.text = String.empty
        commentLabel.font = themeFonts.default(size: .caption)
        commentLabel.textColor = themeColors.contentDividerText
    }
}
extension OneOrderCommentContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {

        let comment = update.summary.comment
        if (String.isNullOrEmpty(comment)) {
            commentLabel.text = String.empty
            return
        }

        commentLabel.text = String(format: OneOrderController.Keys.commentLabel.localized, arguments: [comment])
    }
}
extension OneOrderCommentContainer: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        if (String.isNullOrEmpty(commentLabel.text)) {
            return 0
        }

        let comment = commentLabel.text!
        return 5 + 5 + Int(comment.height(containerWidth: commentLabel.frame.width, font: commentLabel.font!))
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
