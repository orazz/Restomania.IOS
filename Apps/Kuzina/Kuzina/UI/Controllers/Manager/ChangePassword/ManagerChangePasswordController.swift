//
//  ChangePasswordController.swift
//  Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class ManagerChangePasswordController: UIViewController {

    private static let nibName = "ManagerChangePasswordControllerView"
    public static func create() -> ManagerChangePasswordController {

        let vc = ManagerChangePasswordController(nibName: ManagerChangePasswordController.nibName, bundle: Bundle.main)

        return vc
    }

    // MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
        navigationItem.title = "Смена пароля"
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hideNavigationBar()
    }
}
