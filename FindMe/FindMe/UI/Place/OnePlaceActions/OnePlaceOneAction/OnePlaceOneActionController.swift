//
//  OnePlaceOneActionController.swift
//  FindMe
//
//  Created by Алексей on 01.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public protocol OnePlaceOneActionCell: InterfaceTableCellProtocol {

    func update(for: DisplayPlaceInfo, with: Action)
}
public class OnePlaceOneActionController: UIViewController {

    private static let nibname = "OnePlaceOneActionView"
    public static func create(for place:DisplayPlaceInfo, with action: Action) -> OnePlaceOneActionController {

        let vc = OnePlaceOneActionController(nibName: nibname, bundle: Bundle.main)

        vc.place = place
        vc.action = action

        return vc
    }

    //MARK: UI elements
    @IBOutlet private weak var ContentTable: UITableView!
    private var interfaceAdapter: InterfaceTable!
    private var rows: [OnePlaceOneActionCell] = []
    private var refreshControl: UIRefreshControl!
    private var loader: InterfaceLoader!


    //MARK: Data & services
    private var place: DisplayPlaceInfo!
    private var action: Action!
    private var cacheService = CacheServices.actions

    //MARK: View life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()
        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.edgesForExtendedLayout = []
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    private func loadMarkup() {

        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = ThemeSettings.Colors.background
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(needRefreshData), for: .valueChanged)
        ContentTable.addSubview(refreshControl)

        loader = InterfaceLoader(for: self.view)

        self.navigationController?.navigationBar.backgroundColor = ThemeSettings.Colors.background

        let rows = BuildRows()
        interfaceAdapter = InterfaceTable(source: self.ContentTable, navigator: self.navigationController!, rows: rows)
    }
    private func BuildRows() -> [OnePlaceOneActionCell] {

        var result = [OnePlaceOneActionCell]()

        result.append(OnePlaceOneActionNameCell.create(for: self.place, with: self.action))
        result.append(OnePlaceOneActionImageCell.create(for: self.place, with: self.action))
        result.append(OnePlaceOneActionDetailsCell.create(for: self.place, with: self.action))

        return result
    }

    //MARK: Load data
    private func loadData() {

        completeLoadData(with: action)

        requestData()
    }
    @objc private func needRefreshData() {
        requestData()
    }
    private func requestData() {

        let request = cacheService.find(action: action.ID)
        request.async(.background, completion: { response in

            DispatchQueue.main.async {

                if (response.isFail) {

                    self.present(ProblemAlerts.Error(for: response.statusCode), animated: true, completion: {
                        self.completeLoadData(with: response.data)
                    })
                }

                self.completeLoadData(with: response.data )
            }
        })
    }
    private func completeLoadData(with action: Action?) {

        if (refreshControl.isRefreshing) {
            refreshControl.endRefreshing()
        }

        self.action = action
        self.interfaceAdapter.rows.forEach{ ($0 as? OnePlaceOneActionCell)?.update(for: self.place, with: self.action) }
        self.interfaceAdapter.reload()
    }
}
