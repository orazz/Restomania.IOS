//
//  SelectTownCell.swift
//  FindMe
//
//  Created by Алексей on 03.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class SelectTownCell: UITableViewCell {

    public static let identifier = "\(String.tag(SelectTownCell.self))-\(Guid.new)"
    public static let height = CGFloat(35)
    private static let nibName = "SelectTownCell"
    public static func register(in table: UITableView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //MARK: UI Hooks
    @IBOutlet private weak var MarkImage: UIImageView!
    @IBOutlet private weak var NameLabel: UILabel!

    //MARK: Data & Service
    private var town: Town?
    private var service = LogicServices.shared.towns
    private var isSelectCurrentTown = false
    private var isInitMarkup = false

    public func apply(_ town: Town) {

        loadMarkup()

        self.town = town
        self.isSelectCurrentTown = service.isSelected(town)

        updateMark()
    }
    private func loadMarkup() {

        if (isInitMarkup) {
            return
        }
        isInitMarkup = true

        
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (!selected) {
            return
        }

        isSelectCurrentTown = !isSelectCurrentTown

        notifyService()
        updateMark()
    }
    private func notifyService() {

        guard let town = self.town else {
            return
        }

        if (isSelectCurrentTown) {
            service.select(town)
        }
        else {
            service.unselect(town)
        }
    }
    private func updateMark() {

        MarkImage.isHidden = !isSelectCurrentTown
    }
}
