//
//  OneDialogMessage.swift
//  FindMe
//
//  Created by Алексей on 25.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import UIKit

public class OneDialogMessage: UITableViewCell {

    //UI
    @IBOutlet internal weak var backgroundWrapperView: UIView!
    @IBOutlet internal weak var messageLabel: UILabel!
    @IBOutlet internal weak var timeLabel: UILabel!

    //Services
    internal let messagesService = CacheServices.chatMessages

    //Data
    private let _tag = String.tag(OneDialogReceivedMessage.self)
    internal let guid = Guid.new
    internal var message: ChatMessage?
    internal var timeFormatter = DateFormatter(for: "HH:mm")

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundWrapperView.backgroundColor = ThemeSettings.Colors.main
        backgroundWrapperView.layer.cornerRadius = 8.0
        backgroundWrapperView.layer.borderWidth = 0.0
        backgroundWrapperView.layer.borderColor = UIColor.clear.cgColor

        messageLabel.font = ThemeSettings.Fonts.default(size: .caption)
        messageLabel.textColor = ThemeSettings.Colors.blackText

        timeLabel.font = ThemeSettings.Fonts.default(size: .substring)
        timeLabel.textColor = ThemeSettings.Colors.divider


        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));

        messagesService.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewWillDisappear() {
        messagesService.unsubscribe(guid: guid)
    }
    public func willDisplay() {}
    public func update(by message: ChatMessage) {

        self.message = message

        messageLabel.text = message.content
        timeLabel.text = timeFormatter.string(from: message.CreateAt)
    }
    public func countHeight() -> CGFloat {

        let width = UIScreen.main.bounds.width - CGFloat(5.0 + 5.0) - CGFloat(100)
        let containerHeight = message!.content.height(containerWidth: width, font: messageLabel.font)

        return CGFloat(5.0 + 5.0) + CGFloat(5.0 + 5.0) + timeLabel.font.pointSize + containerHeight
    }
}
extension OneDialogMessage: ChatMessagesCacheServiceDelegate {
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
