//
//  LoadingController.swift
//  Launcher
//
//  Created by Алексей on 04.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreTools
import CoreStorageServices
import UITools
import Notifications

public class LoadingController: UIViewController {

    //UI
    @IBOutlet private weak var logo: UIImageView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var status: UILabel!

    //Services
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)
    private let themeImages = DependencyResolver.resolve(ThemeImages.self)

    //Data
    public var onCompleteHandler: Trigger?

    public init() {
        super.init(nibName: String.tag(LoadingController.self), bundle: Bundle.launcher)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func viewDidLoad() {
        super.viewDidLoad()

        logo.image = themeImages.toolsLogo

        indicator.startAnimating()

        status.font = themeFonts.default(size: .head)
        status.textColor = themeColors.contentBackgroundText
        status.text = String.empty

        view.backgroundColor = themeColors.contentBackground
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadCache()
    }
    private func loadCache() {

        status(on: Localization.statusLoadCache.localized)

        AsyncQueue.background.get().async {
            StorageServices.load()

            self.registerPushes()
        }
    }
    private func registerPushes() {

        status(on: Localization.statusRequestPermission.localized)

        let service = NotificationsServices.shared
        if (service.needRequest()) {
            service.requestPermissions()
        }

        complete()
    }
    private func complete() {
        onCompleteHandler?()
    }

    private func status(on value: String) {
        DispatchQueue.main.async {
            self.status.text = value
        }
    }
}
extension LoadingController: LaunchControllerDelegate {
    public var notNeedDisplay: Bool {
        return false
    }

    public func hiddenProcessing() {}
}
extension LoadingController {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(LoadingController.self)
        }
        public var bundle: Bundle {
            return Bundle.launcher
        }

        //Status
        case statusLoadCache = "Status.LoadCache"
        case statusRequestPermission = "Status.RequestPermissions"
    }
}
