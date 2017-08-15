//
//  ManagerController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class ManagerController: UIViewController {

    @IBOutlet weak var price: PriceLabel!

    public override func viewDidLoad() {
        super.viewDidLoad()

        price.setup(amount: 23.4, currency: .RUB)
    }
}
