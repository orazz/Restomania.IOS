//
//  OtherNotificationController.swift
//  CoreFramework
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OtherNotificationController: UIViewController {

    public init() {
        super.init(nibName: String.tag(OtherNotificationController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "Настройки уведомлений"
    }
}
extension OtherNotificationController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(OtherNotificationController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case addButton = "Buttons.Add"
        case loadError = "Messages.ProblemWithLoad"
        case addSuccess = "Messages.SuccessAdd"
        case addError = "Messages.ProblemWithAdd"
        case removeError = "Messages.ProblemWithRemove"
    }
}
