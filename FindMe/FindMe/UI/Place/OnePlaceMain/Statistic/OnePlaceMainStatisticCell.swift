//
//  OnePlaceMainStatisticCell.swift
//  FindMe
//
//  Created by Алексей on 08.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OnePlaceMainStatisticCell: UITableViewCell {

    private static let nibName = "OnePlaceMainStatisticCell"
    public static func create(with navigator: UINavigationController) -> OnePlaceMainStatisticCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceMainStatisticCell

        instance._place = nil
        instance._statistic = nil
        instance._navigator = navigator;
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
    private let _tag = String.tag(OnePlaceMainStatisticCell.self)
    private var _place: DisplayPlaceInfo?
    private var _statistic: ClientsStatistic? {
        didSet {
            updateStatistic()
        }
    }
    private var _navigator: UINavigationController!

    private func initMarkup() {

        InterestinLabel.textColor = ThemeSettings.Colors.main
    }
    private func updateStatistic() {

        AverageAgeLabel?.text = "\(_statistic?.averageAge ?? 0)"
        WomenLabel?.text = "\(_statistic?.females ?? 0)"
        MenLabel?.text = "\(_statistic?.males ?? 0)"
        WomenAcquaintanceLabel?.text = "\(_statistic?.femalesForAcquaintance ?? 0)"
        MenAcquaintanceLabel?.text = "\(_statistic?.malesForAcquaintance ?? 0)"
    }

    //MARK: Actions
    @IBAction private func selectMales() {
        Log.debug(_tag, "Select males statistic.")

        let vc = OnePlaceClientsController.build(for: .male, in: _place!)
        _navigator.pushViewController(vc, animated: true)
    }
    @IBAction private func selectFemales() {
        Log.debug(_tag, "Select females statistic.")

        let vc = OnePlaceClientsController.build(for: .female, in: _place!)
        _navigator.pushViewController(vc, animated: true)
    }
}
extension OnePlaceMainStatisticCell: OnePlaceMainCellProtocol {

    public func update(by place: DisplayPlaceInfo) {
        
        self._place = place
        self._statistic = place.statistic
    }
}
extension OnePlaceMainStatisticCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 140
    }
    public func prepareView() -> UITableViewCell {
        return self
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





