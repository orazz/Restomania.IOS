//
//  PlaceCartController.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask
import IOSLibrary

public class PlaceCartController: UIViewController {

    private static let nibName = "PlaceCartControllerView"
    public static func create(for placeId: Long) -> PlaceCartController {

        let instance = PlaceCartController(nibName: nibName, bundle: Bundle.main)

        return instance
    }
}
