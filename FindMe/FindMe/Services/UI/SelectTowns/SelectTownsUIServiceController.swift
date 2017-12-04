//
//  SelectTownsUIServiceController.swift
//  FindMe
//
//  Created by Алексей on 03.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//


import Foundation
import UIKit
import IOSLibrary
import AsyncTask

public class SelectTownsUIServiceController: UIViewController {

    private static let nibName = "SelectTownsUIServiceController"
    public static var instance: UIViewController {

        let vc = SelectTownsUIServiceController(nibName: nibName, bundle: Bundle.main)

        return vc
    }

    //MARK: UI hooks
    @IBOutlet private weak var TitleLabel: UILabel!
    @IBOutlet private weak var TownsTable: UITableView!
    private var refreshControl: UIRefreshControl!
    private var loader: InterfaceLoader!

    //MARK: Data & services
    private let _tag = String.tag(SelectTownsUIServiceController.self)
    private var loadQueue: AsyncQueue!
    private let townsApi = ApiServices.Places.towns
    private var towns: [Town] = []

    //MARK: View circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        loadMarkup()
        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.edgesForExtendedLayout = []
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    //MARK: Loading
    private func loadMarkup() {

        loader = InterfaceLoader(for: self.view)

        SelectTownCell.register(in: TownsTable)

        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = ThemeSettings.Colors.background
        refreshControl.addTarget(self, action: #selector(needRefreshData), for: .valueChanged)
        TownsTable.addSubview(refreshControl)

        self.navigationController?.navigationBar.backgroundColor = ThemeSettings.Colors.background
    }
    private func loadData() {

        loader.show()

        requestData()
    }
    @objc private func needRefreshData() {
        requestData()
    }
    private func requestData() {
        
        let request = townsApi.all()
        request.async(loadQueue, completion: { response in
            DispatchQueue.main.async {

                if (response.isFail) {
                    self.present(ProblemAlerts.Error(for: response.statusCode), animated: true, completion: nil)
                }

                self.apply(response.data)
            }
        })
    }
    private func apply(_ towns: [Town]?) {

        loader.hide()

        if (refreshControl.isRefreshing) {
            refreshControl.endRefreshing()
        }

        guard let towns = towns else {
            return
        }

        self.towns = towns
        self.TownsTable.reloadData()
    }
}
//MARK: Table
extension SelectTownsUIServiceController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension SelectTownsUIServiceController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return towns.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SelectTownCell.identifier, for: indexPath) as! SelectTownCell
        cell.apply(towns[indexPath.row])

        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectTownCell.height
    }
}
