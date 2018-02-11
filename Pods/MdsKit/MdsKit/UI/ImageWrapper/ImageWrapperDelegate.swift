//
//  ImageWrapperDelegate.swift
//  MdsKit
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageWrapperDelegate {

    var defaultImage: UIImage { get }
    func prepare(url: String, width: CGFloat) -> String
    func download(url: String) -> Task<UIImage?>
}
