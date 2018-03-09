//
//  TermsController.swift
//  UIServices
//
//  Created by Алексей on 10.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class TermsController: UIViewController {

    private var service: WebBrowserController!

    public override func viewDidLoad() {
        super.viewDidLoad()

        let url = "http://medvedstudio.azurewebsites.net/restomania-terms-user.html"
        service = WebBrowserController(delegate: self, for: url)
        service.setTitle(Keys.title.localized)
        
        present(service, animated: false, completion: nil)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
extension TermsController: WebBrowserControllerDelegate {
    public func onCancelTap() {

        service.dismiss(animated: false, completion: nil)

        if let controller = self.navigationController {
            controller.popViewController(animated: false)
        }
        else {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
extension TermsController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(TermsController.self)
        }
        public var bundle: Bundle {
            return Bundle.uiServices
        }

        case title = "Title"
    }
}
