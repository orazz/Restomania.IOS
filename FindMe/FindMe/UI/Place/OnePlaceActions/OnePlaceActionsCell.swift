//
//  OnePlaceActionsCell.swift
//  FindMe
//
//  Created by Алексей on 30.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceActionsCell: UITableViewCell {

    private static let nibName = "OnePlaceActionsCellView"
    private static let defaultHeight = CGFloat()
    public static func create(for action: Action) -> OnePlaceActionsCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! OnePlaceActionsCell
        
        cell.action = action
        cell.loadMarkup()

        return cell
    }

    //MARK: UI
    @IBOutlet private weak var NameLabel: UILabel!
    @IBOutlet private weak var ImageView: ImageWrapper!

    //MARK: Data & services
    private var action: Action! {
        didSet {
            applyAction()
        }
    }

    public var height: CGFloat {

        var result = CGFloat(15) + NameLabel.frame.height

        if (!String.isNullOrEmpty(action.image)) {
            result += CGFloat(5) + ImageView.frame.height + CGFloat(5)
        }

        return result
    }

    private func loadMarkup() {

    }
    private func applyAction() {

        guard let action = self.action else {
            return
        }

        NameLabel.text = action.name

        if (String.isNullOrEmpty(action.image)) {
            ImageView.setContraint(.height, to: 0)
        }
        else {
            ImageView.setContraint(.height, to: 200)
        }
        ImageView.setup(url: action.image)
    }
}
