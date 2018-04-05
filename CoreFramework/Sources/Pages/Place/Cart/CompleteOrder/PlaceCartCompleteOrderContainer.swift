//
//  PlaceCartCompleteOrderContainer.swift
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

        self.setContraint(height: 50)

        connect()
        loadViews()
    }
    private func connect() {

        let nibName = String.tag(PlaceCartCompleteOrderAction.self)
        Bundle.coreFramework.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    public func loadViews() {

        backgroundColor = themeColors.actionMain

        titleLabel.font = themeFonts.default(size: .title)
        titleLabel.textColor = themeColors.actionContent
        titleLabel.text = PlaceCartController.Localization.Buttons.addNewOrder.localized.uppercased()
    }

}
extension PlaceCartCompleteOrderAction: PlaceCartElement {
    public func height() -> CGFloat {
        return self.getConstant(.height)!
    }
}
