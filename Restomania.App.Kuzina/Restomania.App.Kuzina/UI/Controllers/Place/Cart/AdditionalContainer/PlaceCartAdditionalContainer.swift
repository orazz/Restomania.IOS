//
//  PlaceCartAdditionalContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartAdditionalContainer: UITableViewCell {

    private static let nibName = "\(String.tag(PlaceCartAdditionalContainer.self))View"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartContainerCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartAdditionalContainer

        cell.delegate = delegate
        cell.refresh()

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var commentLabel: UITextView!
    @IBOutlet private weak var changeButton: UIButton!
    private var editor = ExternalTextEditor()

    //Data
    private var delegate: PlaceCartDelegate!
    private var container: PlaceCartController.CartContainer {
        return delegate.takeCartContainer()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = ThemeSettings.Fonts.bold(size: .head)
        titleLabel.textColor = ThemeSettings.Colors.main
        titleLabel.text = PlaceCartController.Localization.Labels.comment.localized

        commentLabel.font = ThemeSettings.Fonts.default(size: .caption)

        changeButton.setTitle(PlaceCartController.Localization.Buttons.editComment.localized, for: .normal)

        editor.title = PlaceCartController.Localization.Labels.comment.localized
        editor.onEdit = { update in
            self.container.comment = update
            self.refresh()
        }
    }
    private func refresh() {

        let comment = container.comment
        if (String.isNullOrEmpty(comment)) {
            commentLabel.text = PlaceCartController.Localization.Labels.comment.localized
            commentLabel.textColor = ThemeSettings.Colors.grey
        } else {
            commentLabel.text = comment
            commentLabel.textColor = ThemeSettings.Colors.main
        }
    }
}
extension PlaceCartAdditionalContainer {
    @IBAction private func changeComment() {

        editor.text = container.comment
        delegate.takeController().modal(editor, animated: true)
    }
}
extension PlaceCartAdditionalContainer: PlaceCartContainerCell {
    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func updateData(with: PlaceCartDelegate) {
        refresh()
    }
}
extension PlaceCartAdditionalContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 160
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
