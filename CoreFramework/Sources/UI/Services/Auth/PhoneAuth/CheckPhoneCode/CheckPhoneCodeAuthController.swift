//
//  CheckPhoneCodeAuthController.swift
//  CoreFramework
//
//  Created by Алексей on 12.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import FirebaseAuth

public class CheckPhoneCodeAuthController: UIViewController {

    //UI

    //Services

    //Data
    private let _tag = String.tag(CheckPhoneCodeAuthController.self)
    private let handler: AuthHandler
    private let verificationId: String

    internal init(for verificationId: String, with handler: AuthHandler) {

        self.handler = handler
        self.verificationId = verificationId

        super.init(nibName: String.tag(CheckPhoneCodeAuthController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //Life circle
    public override func loadView() {
        super.loadView()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
