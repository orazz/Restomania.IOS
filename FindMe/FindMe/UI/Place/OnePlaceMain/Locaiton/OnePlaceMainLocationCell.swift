//
//  OnePlaceMainLocationCell.swift
//  FindMe
//
//  Created by Алексей on 17.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OnePlaceMainLocationCell: UITableViewCell {

    private static let nibName = "OnePlaceMainLocationCell"
    public static var instance: OnePlaceMainLocationCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first as! OnePlaceMainLocationCell

        instance._location = nil

        OnePlaceMainLocationCellOneLine.register(in: instance.LocationTable)

        return instance
    }

    //MARK: UI elements
    @IBOutlet public weak var ContentView: UIView!
    @IBOutlet public weak var TitleContainer: UIView!
    @IBOutlet public weak var AddressLabel: UILabel!
    @IBOutlet public weak var LocationTable: UITableView!


    //MARK: Data & Services
    private var _location: Location? {
        didSet {
            updateLocation()
        }
    }
    private var _lines:[LocationLine] = []

    private func updateLocation() {

        if (!needShow()) {
            return
        }

        let location = _location!
        AddressLabel.text = location.address

        _lines = []
        add(location.metro, for: "Метро", to: _lines)
        add(location.borough, for: "Район", to: _lines)
        add(location.city, for: "Город", to: _lines)

        LocationTable.reloadData()

        resize()
    }
    private func add(_ value: String?, for name: String, to range: [LocationLine])  {

        let line = LocationLine(name: name, value: value)
        if (line.isCorrect) {

            _lines.append(line)
        }
    }
    private func resize() {

        LocationTable.layoutIfNeeded()
        let tableHeight = LocationTable.contentSize.height
        LocationTable.setContraint(height: tableHeight)

        var contentHeight = CGFloat(0)
        contentHeight = contentHeight + TitleContainer.getParentConstant(.top)! + TitleContainer.getConstant(.height)!
        contentHeight = contentHeight + LocationTable.getParentConstant(.top)! + tableHeight + CGFloat(5) //Offset bottom

        ContentView.setContraint(height: contentHeight)
    }
    public class LocationLine {

        public let name: String
        public let displayValue: String

        public var isCorrect: Bool {

            return !String.isNullOrEmpty(displayValue)
        }

        public init(name:String, value: String?) {

            self.name = name
            self.displayValue = value ?? String.empty
        }
    }
}



//MARK: Table delegates
extension OnePlaceMainLocationCell: UITableViewDelegate {

}
extension OnePlaceMainLocationCell: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lines.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OnePlaceMainLocationCellOneLine.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: OnePlaceMainLocationCellOneLine.identifier, for: indexPath) as! OnePlaceMainLocationCellOneLine
        cell.setup(data: _lines[indexPath.row])

        return cell
    }
}



//MARK: Cells delegate
extension OnePlaceMainLocationCell: OnePlaceShowDividerDelegate {

    public func needShow() -> Bool {
        return nil != _location
    }
}
extension OnePlaceMainLocationCell: OnePlaceMainCellProtocol {

    public func update(by place: DisplayPlaceInfo) {
        _location = place.location
    }
}
extension OnePlaceMainLocationCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {

        if (needShow()) {
            return Int(ContentView.getConstant(.height)!)
        }
        else {
            return 0
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
