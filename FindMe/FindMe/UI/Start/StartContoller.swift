//
//  StartContoller.swift
//  FindMe
//
//  Created by Алексей on 01.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class StartController: UIViewController {

    private let _tag = String.tag(StartController.self)
    private var isTrySelectTown = false

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let properties = ToolsServices.shared.properties
        let keys = ToolsServices.shared.keys
        let towns = LogicServices.shared.towns

        if (!(properties.getBool(.isShowExplainer).unwrapped ?? false)) {
            toGreetingPage()
        }
        else if (!keys.isAuth(rights: .user)){
            toEnteringPage()
        }
        else if (towns.all().isEmpty && !isTrySelectTown) {
            toSelectTownsPage()
        }
        else {
            toSearch()
        }
    }

    private func toGreetingPage() {

        let greeting = GreetingController.instance
        self.navigationController?.pushViewController(greeting, animated: true)
    }
    private func toEnteringPage() {

        let entering = FirstLoginController.instance
        self.navigationController?.pushViewController(entering, animated: true)
    }
    private func toSelectTownsPage() {

        //Because we can get to user chance not select towns or if we have trouble with internet connection
        isTrySelectTown = true

        let selectTowns = SelectTownsUIService.initialController
        self.navigationController?.pushViewController(selectTowns, animated: true)
    }
    private func toSearch() {

        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = board.instantiateInitialViewController() as? UINavigationController {

            self.navigationController?.present(vc, animated: false, completion: {

                Log.info(self._tag, "Navigate to main storyboard.")
            })
        }
    }
}
