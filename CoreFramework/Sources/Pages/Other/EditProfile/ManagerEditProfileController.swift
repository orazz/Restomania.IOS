//
//  EditProfileController.swift
//  Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class ManagerEditProfileController: UIViewController {

    public init() {
        super.init(nibName: String.tag(ManagerEditProfileController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = "Аккаунт"
    }
}
