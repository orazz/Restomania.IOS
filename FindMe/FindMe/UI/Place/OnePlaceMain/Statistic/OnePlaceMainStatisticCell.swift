//
//  OnePlaceMainStatisticCell.swift
//  FindMe
//
//  Created by Алексей on 08.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainStatisticCell: UITableViewCell {

    private static let nibName = "OnePlaceMainStatisticCell"
    public static var instance: OnePlaceMainStatisticCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainStatisticCell

        instance._place = nil
        instance._statistic = nil
        instance.initMarkup()

        return instance
    }



    //MARK: UI Elements
    @IBOutlet public weak var AverageAgeLabel: FMHeadlineLabel!
    @IBOutlet public weak var WomenLabel: FMHeadlineLabel!
    @IBOutlet public weak var MenLabel: FMHeadlineLabel!
    @IBOutlet public weak var InterestinLabel: FMCaptionLabel!
    @IBOutlet public weak var WomenAcquaintanceLabel: FMHeadlineLabel!
    @IBOutlet public weak var MenAcquaintanceLabel: FMHeadlineLabel!

    //MARK: Data & Services
    private var _place: Place?
    private var _statistic: ClientsData? {
        didSet {
            updateStatistic()
        }
    }

    private func initMarkup() {

        InterestinLabel.textColor = ThemeSettings.Colors.main
    }
    private func updateStatistic() {

        AverageAgeLabel?.text = "\(_statistic?.averageAge ?? 0)"
        WomenLabel?.text = "\(_statistic?.women ?? 0)"
        MenLabel?.text = "\(_statistic?.men ?? 0)"
        WomenAcquaintanceLabel?.text = "\(_statistic?.womenForAcquaintance ?? 0)"
        MenAcquaintanceLabel?.text = "\(_statistic?.menForAcquaintance ?? 0)"
    }
}
extension OnePlaceMainStatisticCell: OnePlaceMainCellProtocol {

    public func update(by place: Place){
        self._place = place
        self._statistic = place.clientsData
    }
}
extension OnePlaceMainStatisticCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 140
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
    public func select(with navigationController: UINavigationController) {

        let vc = OnePlaceClientsController.build(for: _place!)

        navigationController.pushViewController(vc, animated: true)
    }
}
public class OnePlaceMainDivider: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = ThemeSettings.Colors.divider
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = ThemeSettings.Colors.divider
    }
}





