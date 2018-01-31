//
//  AddDishToCartModal.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class AddDishToCartModal: UIViewController {

    //Data
    private let _tag = String.tag(AddDishToCartModal.self)
    private let dish: BaseDish
    private let addings: [Adding]
    private let vartiations: [Variation]
    private let menu: MenuSummary
    private let delegate: PlaceMenuDelegate

    public init(for dish: BaseDish, with addings: [Adding], and variations: [Variation], from menu: MenuSummary, with delegate: PlaceMenuDelegate) {

        self.dish = dish
        self.addings = addings
        self.vartiations = variations
        self.menu = menu
        self.delegate = delegate

        super.init(nibName: "\(String.tag(AddDishToCartModal.self))View", bundle: Bundle.main)
    }

    public required init?(coder aDecoder: NSCoder) {
        Log.error(_tag, "Not implemented constructor.")
        fatalError("init(coder:) has not been implemented")
    }
}
