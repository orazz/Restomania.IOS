//
//  PlaceCartAdditionalContainer.swift
//  CoreFramework
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit  

public class PlaceCartAdditionalContainer: UIView {

    //UI hooks
    @IBOutlet private weak var content: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var commentLabel: UITextView!
    @IBOutlet private weak var takeawayLabel: UILabel!
    @IBOutlet private weak var takeawaySwitch: UISwitch!
    private var editor = ExternalTextEditor()

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var delegate: PlaceCartDelegate?
    private var cart: PlaceCartController.CartContainer? {
        return delegate?.takeCartContainer()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
    private func initialize() {
        connect()
        loadViews()
    }
    private func connect() {

        let nibName = String.tag(PlaceCartAdditionalContainer.self)
        Bundle.coreFramework.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    private func loadViews() {

        backgroundColor = themeColors.contentBackground
        content.backgroundColor = themeColors.contentBackground

        titleLabel.font = themeFonts.bold(size: .head)
        titleLabel.textColor = themeColors.contentText
        titleLabel.text = PlaceCartController.Localization.Labels.comment.localized

        commentLabel.font = themeFonts.default(size: .caption)

        takeawayLabel.font = themeFonts.default(size: .subhead)
        takeawayLabel.textColor = themeColors.contentText
        takeawayLabel.text = PlaceCartController.Localization.Labels.takeaway.localized

        takeawaySwitch.tintColor = themeColors.actionDisabled
        takeawaySwitch.onTintColor = themeColors.actionMain
        takeawaySwitch.addTarget(self, action: #selector(changeTakeaway), for: .valueChanged)

        editor.title = PlaceCartController.Localization.Labels.comment.localized
        editor.onEdit = { update in
            self.cart?.comment = update
            self.refresh()
        }
    }
    private func refresh() {

        let comment = cart?.comment
        if (String.isNullOrEmpty(comment)) {
            commentLabel.text = PlaceCartController.Localization.Labels.comment.localized
            commentLabel.textColor = themeColors.contentTempText
        } else {
            commentLabel.text = comment
            commentLabel.textColor = themeColors.contentText
        }

        if let takeaway = cart?.takeaway {
            takeawaySwitch.setOn(takeaway, animated: true)
        }
    }
}
extension PlaceCartAdditionalContainer {
    @IBAction private func changeComment() {

        editor.text = cart?.comment ?? String.empty
        delegate?.takeController().modal(editor, animated: true)
    }
    @objc private func changeTakeaway() {
        cart?.takeaway = takeawaySwitch.isOn
    }
}
extension PlaceCartAdditionalContainer: PlaceCartElement {
    public func update(with delegate: PlaceCartDelegate) {
        self.delegate = delegate
        refresh()
    }
    public func height() -> CGFloat {
        return 135.0
    }
}
