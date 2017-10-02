//
//  EnteringController.swift
//  FindMe
//
//  Created by Алексей on 02.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask
import IOSLibrary

public class EnteringController: UIViewController {

    private static let nibName = "EnteringView"
    public static func build(parent: StartController) -> EnteringController {

        return EnteringController(nibName: nibName, bundle: Bundle.main)
    }
}
