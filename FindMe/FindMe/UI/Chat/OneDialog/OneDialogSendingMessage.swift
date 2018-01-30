//
//  OneDialogSendingMessage.swift
//  FindMe
//
//  Created by Алексей on 26.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class OneDialogSendingMessage: OneDialogMessage {

    private static let nibName = "\(String.tag(OneDialogSendingMessage.self))View"
    public static func create(for message: ChatMessage) -> OneDialogSendingMessage  {

        let cell: OneDialogSendingMessage = UINib.instantiate(from: nibName, bundle: Bundle.main)
        cell.update(by: message)

        return cell
    }

    //Data
    private let _tag = String.tag(OneDialogSendingMessage.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        messageLabel.textColor = ThemeSettings.Colors.whiteText
        backgroundWrapperView.backgroundColor = ThemeSettings.Colors.additional
    }
}
