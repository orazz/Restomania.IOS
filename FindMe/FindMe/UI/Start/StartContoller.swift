//
//  StartContoller.swift
//  FindMe
//
//  Created by Алексей on 01.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class StartController: UIViewController {

    private let _tag = String.tag(StartController.self)

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let properties = ServicesFactory.shared.properties
        let keys = ServicesFactory.shared.keys

        if (!(properties.getBool(.isShowExplainer).unwrapped ?? false)) {
            toGreetingPage()
        }
        else if (keys.isAuth(rights: .user)){
            toEnteringPage()
        }
        else {
            toSearch()
        }
    }

    public func toGreetingPage() {

        let greeting = GreetingController.build(parent: self)
        self.navigationController?.pushViewController(greeting, animated: false)
    }
    public func toEnteringPage() {

        let entering = EnteringController.build(parent: self)
        self.navigationController?.pushViewController(entering, animated: false)
    }
    public func toSearch() {

        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = board.instantiateInitialViewController() {
            self.navigationController?.present(vc, animated: false, completion: {

                Log.Info(self._tag, "Navigate to main storyboard.")
            })
        }
    }
}
