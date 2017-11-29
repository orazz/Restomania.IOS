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

    //MARK: Data & services
    private var actionsCache = CacheServices.actions
    private var place: DisplayPlaceInfo!
    private var actions: [Action] = []
    private var cache: [Long:OnePlaceActionsCell] = [:]

    //MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()
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

    //MARK: Actions
    @IBAction public func close() {

        navigationController?.popViewController(animated: true)
    }

    //MARK: Processing

}
//MARK:
extension OnePlaceActionsController: UITableViewDelegate {}
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
