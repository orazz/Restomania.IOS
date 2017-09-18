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

    public static let nibName = "PlaceInfoController"

    public init(placeId: Long) {
        super.init(nibName: PlaceInfoController.nibName, bundle: Bundle.main)

    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
