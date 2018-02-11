//
//  OneDialogInputPanelEmojiPicker.swift
//  FindMe
//
//  Created by Алексей on 07.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import Smile

public class OneDialogInputPanelEmojiPicker: NSObject {

    //UI
    private var collection: UICollectionView

    //Data
    private var delegate: OneDialogInputPanelDelegate
    private var emojies: [String]
    private var countInRow: Int

    public init(for collection: UICollectionView, with delegate: OneDialogInputPanelDelegate) {

        self.collection = collection
        self.delegate = delegate
        self.emojies = Smile.list()
        self.countInRow = Int(floor(collection.frame.width / OneDialogInputPanelEmojiCell.side))

        super.init()

        self.collection.delegate = self
        self.collection.dataSource = self
        OneDialogInputPanelEmojiCell.register(in: collection)
    }
}
extension OneDialogInputPanelEmojiPicker: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let side = collectionView.frame.width / CGFloat(countInRow) - 1.0
        return CGSize(width: side, height: side)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if let cell = collectionView.cellForItem(at: indexPath) as? OneDialogInputPanelEmojiCell,
            let emoji = cell.emoji{
            delegate.add(emoji)
        }
    }
}
extension OneDialogInputPanelEmojiPicker: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojies.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OneDialogInputPanelEmojiCell.identifier, for: indexPath) as! OneDialogInputPanelEmojiCell
        cell.update(emojies[indexPath.row * countInRow + indexPath.item])

        return cell
    }
}
