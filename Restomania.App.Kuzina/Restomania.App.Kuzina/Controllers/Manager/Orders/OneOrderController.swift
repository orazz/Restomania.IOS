//
//  OneOrderController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class OneOrderController: UIViewController {

    public static let nibName = "OneOrderView"

    private let _order: DishOrder

    public init(with order: DishOrder) {
        _order = order

        super.init(nibName: OneOrderController.nibName, bundle: Bundle.main)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
