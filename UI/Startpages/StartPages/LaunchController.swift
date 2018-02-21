//
//  StartController.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 22.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreTools
import BaseApp

public class LaunchController: UIViewController {

    private let _tag = String.tag(LaunchController.self)
    private var isShow: Bool = false

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let keys = DependencyResolver.resolve(ApiKeyService.self)
        if (!isShow) && (!keys.isAuth) {
            goToGreeting()
        } else {
            goToSearch()
        }

        isShow = true
    }
    private func goToGreeting() {

        let vc = GreetingController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    private func goToSearch() {

        let board = UIStoryboard(name: "Tabs", bundle: nil)
        let controller = board.instantiateInitialViewController()!

        navigationController?.present(controller, animated: false, completion: {

            Log.debug(self._tag, "Navigate to tabs storyboard.")
        })
    }
}
