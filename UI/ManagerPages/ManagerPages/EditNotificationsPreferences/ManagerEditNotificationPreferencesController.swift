//
//  EditNotificationPreferencesController.swift
//  Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class ManagerEditNotificationPreferencesController: UIViewController {

    private static let nibName = "ManagerEditNotificationPreferencesControllerView"
    public static func create() -> ManagerEditNotificationPreferencesController {

        let vc = ManagerEditNotificationPreferencesController(nibName: nibName, bundle: Bundle.main)

        return vc
    }

    // MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
        navigationItem.title = "Настройки уведомлений"
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hideNavigationBar()
    }
}