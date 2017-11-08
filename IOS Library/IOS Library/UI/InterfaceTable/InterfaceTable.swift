//
//  InterfaceTable.swift
//  IOSLibrary
//
//  Created by Алексей on 08.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class InterfaceTable: NSObject {

    private var _tableView: UITableView
    private var _navigator: UINavigationController

    private var _rows: [InterfaceTableCellProtocol] = []
    public var rows: [InterfaceTableCellProtocol] {
        return _rows.map { $0 }
    }
    public var delegate: UITableViewDelegate?

    public init(source: UITableView, navigator: UINavigationController, rows: [InterfaceTableCellProtocol]) {

        _tableView = source
        _navigator = navigator
        _rows = rows

        super.init()

        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorStyle = .none
    }

    public func add(_ cell: InterfaceTableCellProtocol, reload needReload: Bool = false) {

        _rows.append(cell)

        if (needReload) {
            reload()
        }
    }
    public func reload() {
        _tableView.reloadData()
    }
}

extension InterfaceTable: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cell = _rows[indexPath.row]

        return nil != cell.select
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)

        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath) as? InterfaceTableCellProtocol {

            cell.select?(with: _navigator)
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
}

extension InterfaceTable: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _rows.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = _rows[indexPath.row]

        return  CGFloat(cell.viewHeight)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = _rows[indexPath.row]

        return cell.prepareView()
    }
}
