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

public class LoadingController: UIViewController {

    //UI
    @IBOutlet private weak var logo: UIImageView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var status: UILabel!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeColors.statusBarOnContent
    }

    //Services
    private let deviceService = DependencyResolver.get(DeviceService.self)
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)
    private let themeImages = DependencyResolver.get(ThemeImages.self)

    //Data
    private let _tag: String
    private let loadQueue: AsyncQueue
    private var currentStage = 0
    private var stages:[Trigger] = []
    public var onCompleteHandler: Trigger?

    public init() {

        _tag = String.tag(LoadingController.self)
        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        super.init(nibName: String.tag(LoadingController.self), bundle: Bundle.coreFramework)

        stages = [
            self.loadCache,
            self.requestPushes,
            self.registerDevice,
            self.requestLocation
        ]
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        super.loadView()

        view.backgroundColor = themeColors.contentBackground

        logo.image = themeImages.toolsLogo

        status.font = themeFonts.default(size: .subhead)
        status.textColor = themeColors.contentText
        status.text = String.empty

        indicator.color = themeColors.contentText
        indicator.startAnimating()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        nextStage()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setStatusBarStyle(from: themeColors.statusBarOnContent)
    }

    private func nextStage() {

        if (currentStage >= stages.count) {
            complete()
            return
        }

        let stage = stages[currentStage]
        currentStage += 1

        stage()
    }

    private func complete() {
        onCompleteHandler?()
    }
}
// Stages
extension LoadingController {
    private func loadCache() {

        stageName(Localization.statusLoadCache)

        AsyncQueue.background.get().async {
            StorageServices.load()

            self.nextStage()
        }
    }
    private func requestPushes() {

        stageName(Localization.statusRequestPermission)

        DispatchQueue.main.async {
            PushesService.shared.requestLocalNotifications()

            self.nextStage()
        }
    }

    private func registerDevice() {

        if let _ = deviceService.device {
            nextStage()
            return
        }

        stageName(Localization.statusRegisterDevice)

        let token = PushesService.shared.token ?? Guid.new
        let request = deviceService.register(token: token)
        request.async(loadQueue) { response in

            if (response.isFail) {
                let alert = UIAlertController(title: Localization.alertRegisterDeviceTitle.localized,
                                              message: Localization.alertRegisterDeviceMessage.localized,
                                              preferredStyle: .alert)

                let action = UIAlertAction(title: Localization.alertRegisterDeviceRetryAction.localized,
                                           style: .default,
                                           handler: { _ in  self.registerDevice()})
                alert.addAction(action)

                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }

            if (response.isSuccess) {
                self.nextStage()
            }
        }
    }
    private func requestLocation() {

        stageName(Localization.statusRequestLocationPermissions)

        DispatchQueue.main.async {
            PositionsService.shared.requestPermission()
            PositionsService.shared.startTracking()

            self.nextStage()
        }
    }

    private func stageName(_ value: Localizable) {
        DispatchQueue.main.async {
            self.status.text = value.localized
        }
    }
}
// LaunchControllerDelegate
extension LoadingController: LaunchControllerDelegate {
    public var notNeedDisplay: Bool {
        return false
    }

    public func hiddenProcessing() {}
}
// Localization
extension LoadingController {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(LoadingController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        //Alerts
        case alertRegisterDeviceTitle = "Alerts.RegisterDevice.Title"
        case alertRegisterDeviceMessage = "Alerts.RegisterDevice.Message"
        case alertRegisterDeviceRetryAction = "Alerts.RegisterDevice.RetryAction"

        //Status
        case statusLoadCache = "Status.LoadCache"
        case statusRequestPermission = "Status.RequestPushesPermissions"
        case statusRegisterDevice = "Status.RegisterDevice"
        case statusRequestLocationPermissions = "Status.RequestLocationPremissions"
    }
}
