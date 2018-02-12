//
//  NavigationController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class NavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationBar.backgroundColor = ThemeSettings.Colors.main
    }
}
internal extension UIViewController {

    internal func hideNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    internal func showNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.edgesForExtendedLayout = []
    }
    internal func set(title: String, subtitle: String) {

        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height:0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = ThemeSettings.Colors.additional
        titleLabel.font = ThemeSettings.Fonts.bold(size: .subhead)
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y:  ThemeSettings.Fonts.FontSize.subhead.rawValue, width: 0, height:0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = ThemeSettings.Colors.additional
        subtitleLabel.font = ThemeSettings.Fonts.default(size: .caption)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let width = max(titleLabel.frame.size.width, subtitleLabel.frame.size.width)
        let heigth = ThemeSettings.Fonts.FontSize.subhead.rawValue + ThemeSettings.Fonts.FontSize.caption.rawValue
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: Int(width), height: heigth))
        titleView.backgroundColor = ThemeSettings.Colors.main
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        self.navigationItem.titleView = titleView
    }
}
