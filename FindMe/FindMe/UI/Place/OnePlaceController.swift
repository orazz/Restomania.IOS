//
//  OnePlaceController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceController: UIViewController {

    private static let nibName = "OnePlaceView"
    public static func build(placeId: Long) -> OnePlaceController {

        let instance = OnePlaceController(nibName: nibName, bundle: Bundle.main)

        instance.placeId = placeId

        return instance
    }


    //MARK: UIElements
    private var _loader: InterfaceLoader!

    //MARK: Data
    public var placeId: Long!


    //View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
}
