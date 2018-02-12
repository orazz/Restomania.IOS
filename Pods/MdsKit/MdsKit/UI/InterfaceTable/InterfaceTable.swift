//
//  InterfaceTable.swift
//  MdsKit
//
//  Created by Алексей on 08.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class InterfaceTable: NSObject {

    fileprivate var _tableView: UITableView
    fileprivate var _navigator: UINavigationController?

    fileprivate var _rows: [InterfaceTableCellProtocol] = []
    public var rows: [InterfaceTableCellProtocol] {
        return _rows.map { $0 }
    }
    public var delegate: UITableViewDelegate?

    public init(source: UITableView, navigator: UINavigationController? = nil, rows: [InterfaceTableCellProtocol] = []) {

        _tableView = source
        _navigator = navigator

        super.init()

        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorStyle = .none

        for cell in rows {
            addAndConnect(cell)
        }
    }

    public func add(_ cell: InterfaceTableCellProtocol, reload needReload: Bool = false) {

        addAndConnect(cell)

        if (needReload) {
            reload()
        }
    }
    private func addAndConnect(_ cell: InterfaceTableCellProtocol) {

        let newNumber = rows.count
        cell.addToContainer?(handler: {
            let indexPath = IndexPath(row: newNumber, section: 0)
            if let _ = self._tableView.cellForRow(at: indexPath) {
                self._tableView.reloadRows(at: [indexPath], with: .none)
            }
            else {
                self._tableView.reloadData()
            }
        })

        _rows.append(cell)
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

        if let cell = tableView.cellForRow(at: indexPath) as? InterfaceTableCellProtocol,
            let method = cell.select,
            let navigator = _navigator {

            method(navigator)
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