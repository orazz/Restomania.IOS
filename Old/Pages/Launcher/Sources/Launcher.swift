//
//  Launcher.swift
//  Launcher
//
//  Created by Алексей on 04.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreTools
import UITools

typealias VCCtor = () -> LaunchControllerDelegate & UIViewController
public class Launcher {

    private let tag = String.tag(Launcher.self)
    private var completeLaunch: Bool = false

    private var delegate: UIApplicationDelegate
    private var launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    private var navigator: NavigationController
    private let controllers: [VCCtor]
    private var notification: [AnyHashable: Any]? = nil

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)

    public init(for delegate: UIApplicationDelegate, with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

        self.delegate = delegate
        self.launchOptions = launchOptions

        self.navigator = NavigationController()

        self.controllers = Launcher.launchControllers()
    }

    public var window: UIWindow {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigator
        window.makeKeyAndVisible()
        window.backgroundColor = themeColors.contentBackground

        return window
    }

    public func processNotification(_ notification: [AnyHashable: Any]) {

        if (!completeLaunch) {
            return
        }

//        PushesService.shared.build(notification, completeHandler: { result in
//
//            if let vc = result.vc?() {
//                DispatchQueue.main.async {
//                    Router.shared.navigator.pushViewController(vc, animated: true)
//                }
//            }
//        })
    }

    public func start(complete: Trigger? = nil) {

        if let options = launchOptions,
            let notification = options[.remoteNotification] as? [AnyHashable: Any] {
            self.notification = notification
//            PushesService.shared.ignore(notification)
        }

        continueLaunch(from: 0)
    }
    private func continueLaunch(from step: Int) {

        if (step >= controllers.count) {
            complete()
            return
        }



        let ctor = controllers[step]
        var vc = ctor()
        let nextStep = step + 1

        if (vc.notNeedDisplay) {
            vc.hiddenProcessing()
            continueLaunch(from: nextStep)
            return
        }



        vc.onCompleteHandler = {
            self.continueLaunch(from: nextStep)
        }

        if let old = navigator.presentedViewController {
            old.dismiss(animated: false, completion: {
                self.display(vc)
            })
        }
        else {
            display(vc)
        }
    }
    private func display(_ vc: UIViewController) {
        navigator.present(vc, animated: false, completion: nil)
    }
    private func complete() {
        if (completeLaunch) {
            return
        }

        completeLaunch = true
        Log.info(tag, "Complete launch")

        if let old = self.navigator.presentedViewController {
            old.dismiss(animated: false, completion: nil)
        }

        let tabs = TabsController()
        let navigator = NavigationController(rootViewController: tabs)
        self.navigator = navigator
//        Router.initialize(<#T##Router#>)
//        Router.shared.navigator = navigator
//        Router.shared.tabs = tabs

        self.delegate.window??.rootViewController = navigator


        if let notification = self.notification {
            processNotification(notification)
        }
    }
    private static func launchControllers() -> [VCCtor] {

        return [
            { LoadingController() },
            { GreetingController() }
        ]
    }
}
