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

    public private(set) var key: String
    public private(set) var data: JSON?
    public private(set) var banner: BannerAlert?
    public private(set) var controller: (() -> UIViewController?)?
    public private(set) var event: NotificationEvents

    public init() {

        self.key = Guid.new
        self.data = nil
        self.banner = nil
        self.controller = nil
        self.event = .test
    }
}
