//
//  WebBrowserControllerDelegate.swift
//  UIServices
//
//  Created by Алексей on 09.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

internal protocol WebBrowserControllerDelegate {

    func startLoad(url: URL, parameters: [String:String])
    func completeLoad(url: URL, parameters: [String:String])
    func failLoad(url: URL, parameters: [String:String], error: Error)

    func onCancelTap()
}
extension WebBrowserControllerDelegate {
    func startLoad(url: URL, parameters: [String:String]) {}
    func completeLoad(url: URL, parameters: [String:String]) {}
    func failLoad(url: URL, parameters: [String:String], error: Error) {}

    func onCancelTap() {}
}
