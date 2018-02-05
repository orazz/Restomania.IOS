//
//  FMSwitchRow.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class FMSwitchRow: UITableViewCell {

    public static func create(for source: FMSwitch) -> FMSwitchRow {

        let cell: FMSwitchRow = UINib.instantiate(from: "\(String.tag(FMSwitchRow.self))View", bundle: Bundle.main)
        cell.source = source

        return cell
    }

    //UI
    public private(set) var source: FMSwitch! {
        didSet {
            self.addSubview(source)
            source.frame = self.bounds
            source.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            source.setContraint(height: CGFloat(FMTextField.height))
        }
    }
}
extension FMSwitchRow: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return Int(FMSwitch.height)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
