//
//  WebBrowserController.swift
//  UIServices
//
//  Created by Алексей on 07.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

internal protocol WebBrowserControllerDelegate {
    
}
internal class WebBrowserController: UIViewController {

    @IBOutlet private weak var navigationBar: UINavigationBar!
    private weak var cancelButtom: UIBarButtonItem!
    private weak var activityindicator: UIActivityIndicatorView!



    internal init() {
        super.init(nibName: String.tag(WebBrowserController.self), bundle: Bundle.uiServices)
    }
    internal convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }


}
