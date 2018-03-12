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

typealias VCCtor = () -> LaunchControllerDelegate & UIViewController
public class Launcher {

    private let tag = String.tag(Launcher.self)
    private var completeLaunch: Bool = false

    private var delegate: UIApplicationDelegate
    private var launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    private var navigator: NavigationController
    private let controllers: [VCCtor]
    private var notification: PushContainer? = nil

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let router = DependencyResolver.resolve(Router.self)

    public init(for delegate: UIApplicationDelegate, with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

        self.delegate = delegate
        self.launchOptions = launchOptions

        self.navigator = NavigationController()

        self.controllers = [
            { LoadingController() },
            { GreetingController() }
        ]
    }

    public var window: UIWindow {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = themeColors.contentBackground

        return window
    }


    public func start(complete: Trigger? = nil) {

        router.initialize(with: navigator)

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
        router.initialize(with: navigator)
        router.initialize(with: tabs)

        if let notification = self.notification {
            processNotification(notification)
        }
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
}
