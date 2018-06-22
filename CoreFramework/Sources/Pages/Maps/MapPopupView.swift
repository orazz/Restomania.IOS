//
//  MapPopupView.swift
//  CoreFramework
//
//  Created by Oraz Atakishiyev on 6/21/18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

class MapPopupView: UIView {
    
    @IBOutlet private weak var ImageView: CachedImage!
    @IBOutlet private weak var TitleLab: UILabel!
    @IBOutlet private weak var DescriptionLab: UILabel!
    
    public let height = CGFloat(150)
    
    func setPlaceData(place: PlaceSummary) {
        self.TitleLab.text = place.Name
        self.DescriptionLab.text = place.Description
        self.ImageView.setup(url: place.Image)
    }
}
