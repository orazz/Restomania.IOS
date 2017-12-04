//
//  OnePlaceActionsController.swift
//  FindMe
//
//  Created by Алексей on 29.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import AsyncTask

public class OnePlaceActionsController: UIViewController {

    private static let nibName = "OnePlaceActionsView"
    public static func create(for place: DisplayPlaceInfo) -> OnePlaceActionsController {

        let vc = OnePlaceActionsController(nibName: nibName, bundle: Bundle.main)

        vc.place = place

        return vc
    }
    //MARK: UI
    @IBOutlet private weak var ActionsTable: UITableView!
    private var refreshControl: UIRefreshControl!
    private var loader: InterfaceLoader!

    //MARK: Data & services
    private let _tag = String.tag(OnePlaceActionsController.self)
    private var actionsCache = CacheServices.actions
    private var place: DisplayPlaceInfo! 
    private var actions: [Action] = []
    private var cache: [Long:OnePlaceActionsCell] = [:]

    //MARK: Life circle
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

        cache.removeAll()
    }
    private func loadMarkup() {

        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = ThemeSettings.Colors.background
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(needRefreshData), for: .valueChanged)
        ActionsTable.addSubview(refreshControl)

        loader = InterfaceLoader(for: self.view)

        self.navigationController?.navigationBar.backgroundColor = ThemeSettings.Colors.background
    }

    //MARK: Load data
    private func loadData() {

        let cached = actionsCache.cache.all.filter({ $0.placeId == place.ID })
        if (cached.isFilled) {
            completeLoadData(with: cached)
        }
        else {
            loader.show()
        }

        requestData()
    }
    @objc private func needRefreshData() {
        requestData()
    }
    private func requestData() {

        let request = actionsCache.find(place: place.ID, with: SelectParameters())
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
    private func completeLoadData(with actions: [Action]?) {

        if (refreshControl.isRefreshing) {
            refreshControl.endRefreshing()
        }
        loader.hide()

        let filtered = (actions ?? []).sorted(by: { $0.orderNumber < $1.orderNumber } )
                                      .filter({ !$0.isHide })

        self.actions = filtered
        ActionsTable.reloadData()
    }
}
//MARK:
extension OnePlaceActionsController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let action = actions[indexPath.row]
        let vc = OnePlaceOneActionController.create(for: place, with: action)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension OnePlaceActionsController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return takeOrCreateCell(for: indexPath)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return takeOrCreateCell(for: indexPath).height
    }
    private func takeOrCreateCell(for indexPath: IndexPath) -> OnePlaceActionsCell {

        let action = actions[indexPath.row]
        if let cached = cache[action.ID] {
            return cached
        }

        let cached = OnePlaceActionsCell.create(for: action)
        cache[action.ID] = cached

        return cached
    }
}
