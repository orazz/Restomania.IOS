//
//  IFIlter.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public protocol IFilter {

    func search(phrase: String, field: Any) -> Bool
}
