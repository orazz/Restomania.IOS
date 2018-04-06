//
//  DishModalSelectVariations.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectVariations: UITableViewCell {

    public static func create(for variations: [Variation], from menu: MenuSummary, with delegate: AddDishToCartModalDelegateProtocol) -> DishModalSelectVariations {

        let nibname = String.tag(DishModalSelectVariations.self)
        let cell: DishModalSelectVariations = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.variations = variations.ordered
        cell.menu = menu
        cell.delegate = delegate

        cell.initialize()

        return cell
    }

    //UI
    @IBOutlet private weak var variationsTable: UITableView!

    //Data
    private var variations: [Variation] = []
    private var menu: MenuSummary!
    private var delegate: AddDishToCartModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        DishModalSelectVariationsCell.register(in: variationsTable)
        variationsTable.delegate = self
        variationsTable.dataSource = self
    }
    private func initialize() {

        variationsTable.reloadData()

        var selectedPosition = IndexPath(row: 0, section: 0)
        if let variation = delegate?.selectedVariation,
            let index = variations.index(where: { $0.id == variation.id }) {
            selectedPosition = IndexPath(row: index, section: 0)
        }

        tableView(variationsTable, didSelectRowAt: selectedPosition)
        variationsTable.selectRow(at: selectedPosition, animated: true, scrollPosition: .top)
    }
}
extension DishModalSelectVariations: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.select(variation: variations[indexPath.row])
    }
}
extension DishModalSelectVariations: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variations.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DishModalSelectVariationsCell.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: DishModalSelectVariationsCell.identifier, for: indexPath) as! DishModalSelectVariationsCell
        cell.setup(for: variations[indexPath.row], with: menu)

        return cell
    }
}
extension DishModalSelectVariations: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return Int(variationsTable.contentSize.height)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
