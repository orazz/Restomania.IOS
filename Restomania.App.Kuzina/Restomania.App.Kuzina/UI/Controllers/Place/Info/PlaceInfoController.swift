//
//  PlaceInfoController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 13.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceInfoController: UIViewController {

    private static let nibName = "PlaceInfoControllerView"
    public static func create(for placeid: Long) -> PlaceInfoController {

        let vc = PlaceInfoController(nibName: nibName, bundle: Bundle.main)

        return vc
    }
}
