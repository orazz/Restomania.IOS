//
//  ProfileControllerSelectTowns.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ProfileControllerSelectTowns: UITableViewCell {

    public static func create(for delegate: ProfileControllerDelegate) -> ProfileControllerSelectTowns {

        let cell: ProfileControllerSelectTowns = UINib.instantiate(from: "\(String.tag(ProfileControllerSelectTowns.self))View", bundle: Bundle.main)
        cell.delegate = delegate

        return cell
    }

    //Data
    private var delegate: ProfileControllerSelectTowns!

    //Actions
    @IBAction private func selectTown() {
        delegate.selectTown()
    }
}
extension ProfileControllerSelectTowns: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 60
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
