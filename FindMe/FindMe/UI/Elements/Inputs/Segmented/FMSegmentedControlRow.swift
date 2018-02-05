//
//  FMSegmentedControlRow.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class FMSegmentedControlRow: UITableViewCell {

    public static func create(for source: FMSegmentedControl) -> FMSegmentedControlRow {

        let cell: FMSegmentedControlRow = UINib.instantiate(from: "\(String.tag(FMSegmentedControlRow.self))View", bundle: Bundle.main)
        cell.source = source

        return cell
    }

    //UI
    public private(set) var source: FMSegmentedControl! {
        didSet {
            self.addSubview(source)
            source.frame = self.bounds
            source.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            source.setContraint(height: CGFloat(FMTextField.height))
        }
    }
}
extension FMSegmentedControlRow: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return Int(FMSegmentedControl.height)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
