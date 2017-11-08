//
//  PlaceCartCompleteDateContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartCompleteDateContainer: UITableViewCell {

    private static let nibName = "PlaceCartDateContainerView"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartCompleteDateContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartCompleteDateContainer

        cell.delegate = delegate

        return cell
    }

    //UI elements
    @IBOutlet private weak var scheduleView: ScheduleDisplay!

    //Data
    private var delegate: PlaceCartDelegate! {
        didSet {
            update()
        }
    }
    private var container: PlaceCartController.CartContainer {
        return delegate.takeContainer()
    }

    private func update() {

        if let schedule = delegate.takeSummary()?.Schedule {
            scheduleView.update(by: schedule)
        }
    }
    private func setupMarkup() {

    }
}
extension PlaceCartCompleteDateContainer: PlaceCartContainerCell {
    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func updateData(with delegate: PlaceCartDelegate) {
        self.delegate = delegate
    }
}
extension PlaceCartCompleteDateContainer: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 300
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
