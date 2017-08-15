//
//  StartController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class StartController: UIViewController {
    
    private let _tag = "StartController"
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let storage = ServicesManager.current.keysStorage
        if let _ = storage.keysFor(rights: .User) {
            
            goToSearch()
        }
    }
    
    private func goToSearch() {
        
        let board = UIStoryboard(name: "Tabs", bundle: nil)
        let controller = board.instantiateInitialViewController()!
        
        navigationController?.present(controller, animated: true, completion: {
            
            Log.Debug(self._tag, "Navigate to tabs storyboard.")
        })
    }
}
