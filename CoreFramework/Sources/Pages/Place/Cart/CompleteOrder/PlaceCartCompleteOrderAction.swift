//
//  PlaceCartCompleteOrderAction.swift
//  CoreFramework
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartCompleteOrderAction: UIView {

    //UI hooks
    @IBOutlet private weak var content: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    private var heightConstraint: NSLayoutConstraint!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var delegate: PlaceCartDelegate!

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

        let nibName = String.tag(PlaceCartCompleteOrderAction.self)
        Bundle.coreFramework.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        heightConstraint = self.constraints.find({ $0.firstAttribute == .height })
        heightConstraint.constant = 50.0
    }
    public func loadViews() {

        content.backgroundColor = themeColors.actionMain

        titleLabel.font = themeFonts.default(size: .title)
        titleLabel.textColor = themeColors.actionContent
        titleLabel.text = PlaceCartController.Localization.Buttons.addNewOrder.localized.uppercased()
    }

    @IBAction private func addOrder() {
        delegate?.tryAddOrder()
    }
}
extension PlaceCartCompleteOrderAction: PlaceCartElement {
    public func update(with delegate: PlaceCartDelegate) {
        self.delegate = delegate
    }
    public func height() -> CGFloat {
        return heightConstraint.constant
    }
}
