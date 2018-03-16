//
//  PlaceInfoController.swift
//  CoreFramework
//
//  Created by Алексей on 13.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceInfoController: UIViewController {

    //UI

    //Data
    private let placeId: Long

    //Service

    public init(for placeId: Long) {
        self.placeId = placeId

        super.init(nibName: "\(String.tag(PlaceInfoController.self))View", bundle: Bundle.coreFramework)
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(for: -1)
    }
}
