//
//  FMTextFieldRow.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class FMTextFieldRow: UITableViewCell {

    public static func create(for source: FMTextField) -> FMTextFieldRow {

        let cell: FMTextFieldRow = UINib.instantiate(from: "\(String.tag(FMTextFieldRow.self))View", bundle: Bundle.main)
        cell.source = source

        return cell
    }

    //UI
    public private(set) var source: FMTextField! {
        didSet {
            self.addSubview(source)
            source.frame = self.bounds
            source.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            source.setContraint(height: CGFloat(FMTextField.height))
        }
    }
}
extension FMTextFieldRow: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return Int(FMTextField.height)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
