//
//  OnePlaceMainDescriptionCell.swift
//  FindMe
//
//  Created by Алексей on 13.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainDescriptionCell: UITableViewCell {

    private static let nibName = "OnePlaceMainDescriptionCell"
    public static var instance: OnePlaceMainDescriptionCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainDescriptionCell

        instance._description = nil

        return instance
    }

    //MARK: UI Elements
    @IBOutlet public weak var ContentView: UIView!
    @IBOutlet public weak var TitleLabel: UILabel!
    @IBOutlet public weak var DescriptionLabel: UILabel!


    //MARK: Data & services
    private var _description: String? {
        didSet{
            updateDescription()
        }
    }

    private func updateDescription() {

        DescriptionLabel?.text = _description
        resize()
    }
    private func resize() {

        if (!needShow()) {
            return
        }

        let labelHeight = _description!.height(containerWidth: DescriptionLabel.frame.width, font: DescriptionLabel.font)
//        DescriptionLabel.setContraint(height: labelHeight)

        var contentHeight = CGFloat(0)
        contentHeight = contentHeight + TitleLabel.getParentConstant(.top)! + TitleLabel.frame.height
        contentHeight = contentHeight +  DescriptionLabel.getParentConstant(.top)! + CGFloat(10)//bottom offset

        ContentView.setContraint(height: contentHeight + labelHeight)
    }
}
extension OnePlaceMainDescriptionCell: OnePlaceShowDividerDelegate {

    public func needShow() -> Bool {
        return !String.isNullOrEmpty(_description)
    }
}
extension OnePlaceMainDescriptionCell: OnePlaceMainCellProtocol {

    public func update(by place: DisplayPlaceInfo) {
        _description = place.description
    }
}
extension OnePlaceMainDescriptionCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        if (!needShow()) {
            return 0
        }
        else {
            return Int(ContentView.getConstant(.height)!)
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
