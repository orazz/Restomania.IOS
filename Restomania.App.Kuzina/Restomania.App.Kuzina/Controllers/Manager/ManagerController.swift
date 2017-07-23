//
//  ManagerController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class ManagerController: UIViewController {

    @IBOutlet weak var Label: UILabel!
    private var _theme: ThemeSettings!

    public override func viewDidLoad() {
        super.viewDidLoad()

        _theme = AppSummary.current.theme

        Label.text = "\u{f15a}"
        Label.font = UIFont(name: _theme.fontAwesomeFont, size: 30)
    }
}
