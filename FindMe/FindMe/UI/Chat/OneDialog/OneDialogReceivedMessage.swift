//
//  OneDialogReceivedMessage.swift
//  FindMe
//
//  Created by Алексей on 25.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import UIKit

public class OneDialogMessage: UITableViewCell {
    public func viewWillDisappear() {}
    public func update(by message: ChatMessage) {}
}
public class OneDialogReceivedMessage: OneDialogMessage {

    private static let nibName = "\(String.tag(OneDialogReceivedMessage.self))View"
    public static func create(for message: ChatMessage) -> OneDialogReceivedMessage  {

        let cell: OneDialogReceivedMessage = UINib.instantiate(from: nibName, bundle: Bundle.main)
        cell.update(by: message)

        return cell
    }

    //UI
    @IBOutlet private weak var backgroundWrapperView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    //Services
    private let messagesService = CacheServices.chatMessages

    //Data
    private let _tag = String.tag(OneDialogReceivedMessage.self)
    private let guid = Guid.new
    private var message: ChatMessage?
    private var timeFormatter = DateFormatter(for: "HH:mm")

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundWrapperView.backgroundColor = ThemeSettings.Colors.main
        backgroundWrapperView.layer.cornerRadius = 8.0
        backgroundWrapperView.layer.borderWidth = 0.0
        backgroundWrapperView.layer.borderColor = UIColor.clear.cgColor

        messageLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        messageLabel.textColor = ThemeSettings.Colors.blackText

        timeLabel.font = ThemeSettings.Fonts.default(size: .substring)
        timeLabel.textColor = ThemeSettings.Colors.divider


        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));

        messagesService.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public override func viewWillDisappear() {
        messagesService.unsubscribe(guid: guid)
    }
    public override func update(by message: ChatMessage) {

        self.message = message

        messageLabel.text = message.content
        timeLabel.text = timeFormatter.string(from: message.CreateAt)
    }
}
extension OneDialogReceivedMessage: ChatMessagesCacheServiceDelegate {
    public func messagesService(_ service: ChatMessagesCacheService, new message: ChatMessage) {
        applyChanges(for: message)
    }
    public func messagesService(_ service: ChatMessagesCacheService, change message: ChatMessage) {
        applyChanges(for: message)
    }
    public func messagesService(_ service: ChatMessagesCacheService, updates messages: [ChatMessage]) {
        applyChanges(for: messages.find({ $0.ID == self.message?.ID }))
    }
    private func applyChanges(for message: ChatMessage?) {
        if let update = message,
            update.ID == self.message?.ID {

            DispatchQueue.main.async {
                self.update(by: update)
            }
        }
    }
}
