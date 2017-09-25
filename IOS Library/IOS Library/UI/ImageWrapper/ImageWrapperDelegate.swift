//
//  ImageWrapperDelegate.swift
//  IOS Library
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask

public protocol ImageWrapperDelegate {

    var defaultImage: UIImage { get }
    func prepare(url: String, width: CGFloat) -> String
    func download(url: String) -> Task<UIImage?>
}
