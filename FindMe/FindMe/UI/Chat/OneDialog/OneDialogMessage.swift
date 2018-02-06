//
//  OneDialogMessage.swift
//  FindMe
//
//  Created by Алексей on 25.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import UIKit

public class OneDialogMessage: UITableViewCell {

    //UI
    @IBOutlet internal weak var backgroundWrapperView: UIView!
    @IBOutlet internal weak var messageLabel: UILabel!
    @IBOutlet internal weak var timeLabel: UILabel!
    private var countedHeight: CGFloat? = nil

    //Services
    internal let messagesService = CacheServices.chatMessages

    //Data
    private let _tag = String.tag(OneDialogReceivedMessage.self)
    internal let guid = Guid.new
    public var message: DialogMessageModelProtocol!

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
    public func viewWillDisappear() {
        messagesService.unsubscribe(guid: guid)
    }
    public func willDisplay() {}
    public func apply(_ message: DialogMessageModelProtocol) {

        self.message = message

        self.messageLabel.text = message.content
        self.timeLabel.text = message.formattedCreateAt
    }
    public var height: CGFloat {

        if let height = countedHeight {
            return height
        }

        let counted = countHeight()
        countedHeight = counted

        return counted
    }
    private func countHeight() -> CGFloat {

        let width = UIScreen.main.bounds.width - CGFloat(5.0 + 5.0) - CGFloat(100)
        let containerHeight = message!.content.height(containerWidth: width, font: messageLabel.font)

        return CGFloat(5.0 + 5.0) + CGFloat(5.0 + 5.0) + timeLabel.font.pointSize + containerHeight
    }
}
extension OneDialogMessage: ChatMessagesCacheServiceDelegate {
    public func messagesService(_ service: ChatMessagesCacheService, change message: ChatMessage) {
        applyChanges(for: message)
    }
    public func messagesService(_ service: ChatMessagesCacheService, updates messages: [ChatMessage]) {
        applyChanges(for: messages.find({ $0.ID == self.message?.id }))
    }
    private func applyChanges(for message: ChatMessage?) {

        if let update = message,
            let source = self.message,
            update.ID == self.message?.id {

            source.update(by: update)
            
            DispatchQueue.main.async {
                self.apply(source)
            }
        }
    }
}
