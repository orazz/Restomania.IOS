//
//  UIServices.swift
//  CoreUIServices
//
//  Created by Алексей on 13.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Swinject
import CoreTools
import CoreApiServices

open class UIServices {

    open static func register(in container: Container) {

        container.register(AddCardUIService.self, factory: { r in AddCardUIService(r.resolve(UserCardsApiService.self)!) })
    }
}
