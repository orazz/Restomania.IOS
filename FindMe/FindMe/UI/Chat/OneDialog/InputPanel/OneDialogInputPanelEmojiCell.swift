//
//  OneDialogInputPanelEmojiCell.swift
//  FindMe
//
//  Created by Алексей on 07.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OneDialogInputPanelEmojiCell: UICollectionViewCell {

    public static let identifier = Guid.new
    public static let side = CGFloat(50)
    public static func register(in collection: UICollectionView) {

        let nib = UINib(nibName: String.tag(OneDialogInputPanelEmojiCell.self), bundle: Bundle.main)
        collection.register(nib, forCellWithReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var emojiLabel: UILabel!

    //Data
    public private(set) var emoji: String? {
        didSet {
            emojiLabel.text = emoji
        }
    }

    //Circle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func update(_ value: String) {
        emoji = value
    }
}
