//
//  NotificationContainer.swift
//  CoreFramework
//
//  Created by Алексей on 12.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import UIKit
import Gloss

public class NotificationContainer {

    public var id: String
    public var sound: String?
    public var silent: Bool
    public var data: JSON?
    public var event: NotificationEvents
    public var banner: BannerAlert?
    public var controller: UIViewController?

    public init() {

        self.id = Guid.new
        self.sound = nil
        self.silent = true
        self.data = nil
        self.event = .test
        self.banner = nil
        self.controller = nil
    }

    public convenience init(from push: PushContainer) {
        self.init()

        self.id = push.id
        self.sound = push.sound
        self.silent = push.silent
        self.data = push.data
        self.event = push.event
    }
}
