//
//  PaymentCardsController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class PaymentCardsController: UIViewController {
    
    public static let nibName = "PaymentCardsView"
    
    public init() {
        
        super.init(nibName: PaymentCardsController.nibName, bundle: Bundle.main)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
