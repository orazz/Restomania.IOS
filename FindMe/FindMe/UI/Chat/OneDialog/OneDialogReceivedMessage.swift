//
//  OneDialogReceivedMessage.swift
//  FindMe
//
//  Created by Алексей on 25.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import UIKit


public class OneDialogReceivedMessage: OneDialogMessage {

    private static let nibName = "\(String.tag(OneDialogReceivedMessage.self))View"
    public static func create(for message: DialogMessageModelProtocol) -> OneDialogReceivedMessage  {

        let cell: OneDialogReceivedMessage = UINib.instantiate(from: nibName, bundle: Bundle.main)
        cell.apply(message)

        return cell
    }

    //Data
    private let _tag = String.tag(OneDialogReceivedMessage.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        messageLabel.textColor = ThemeSettings.Colors.whiteText
        backgroundWrapperView.backgroundColor = ThemeSettings.Colors.main
    }
    public override func willDisplay() {
        super.willDisplay()

        if let message = message {
            if (message.deliveryStatus != .isRead) {
                let request = messagesService.markAsRead(message.id)
                request.async(.background, completion: { _ in })
            }
        }
    }
}
