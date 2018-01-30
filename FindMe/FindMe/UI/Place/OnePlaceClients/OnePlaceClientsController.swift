//
//  OnePlaceClientsController.swift
//  FindMe
//
//  Created by Алексей on 31.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceClientsController: UIViewController {

    private static let nibName = "OnePlaceClientsView"
    public static func build(for sex: UserSex, in place: DisplayPlaceInfo) -> OnePlaceClientsController {

        let vc = OnePlaceClientsController(nibName: nibName, bundle: Bundle.main)

        vc.place = place
        vc.selectedSex = sex
        vc.apiClient = ApiServices.Places.clients

        return vc
    }

    //MARK: UI elements
    @IBOutlet private weak var sexSegment: FMSegmentedControl!
    @IBOutlet private weak var clientsTable: UITableView!
    private var loader: InterfaceLoader!
    private var refreshControl: UIRefreshControl!

    //MARK: Data & services
    private var _tag = String.tag(OnePlaceClientsController.self)
    private var apiClient: PlacesClientsApiService!
    private var place: DisplayPlaceInfo!
    private var selectedSex: UserSex! {
        didSet {
            updateFiltered()
        }
    }
    private var clients: [PlaceClient] = []{
        didSet {
            updateFiltered()
        }
    }
    private var filtered: [PlaceClient] = []

    //MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupMarkup()

        loadData(refresh: false)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.edgesForExtendedLayout = []
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    private func setupMarkup() {

        loader = InterfaceLoader(for: self.view)

        self.title = place.name

        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = ThemeSettings.Colors.background
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(needRefreshData), for: .valueChanged)
        clientsTable.addSubview(refreshControl)

        updateSegmentControl()
        sexSegment.onChangeEvent = changeSex(_:index:value:)

        self.navigationController?.navigationBar.backgroundColor = ThemeSettings.Colors.background

        OnePlaceClientsCell.register(in: clientsTable)
    }
    @objc private func needRefreshData() {
        loadData(refresh: true)
    }
    private func loadData(refresh: Bool) {

        if (!refresh) {
            loader.show()
        }

        let request = apiClient.all(in: place.ID)
        request.async(.background, completion: { response in

            DispatchQueue.main.async {
                if (response.isSuccess) {

                    self.clients = response.data!
                }
                else {
                    Log.warning(self._tag, "Problem with getting clients data.")

                    if (response.statusCode == .ConnectionError) {

                        self.show(ProblemAlerts.NotConnection, sender: nil)
                    }
                }

                self.completeLoad()
            }
        })
    }
    private func completeLoad() {

        updateSegmentControl()
        updateInterface()

        loader.hide()

        if (refreshControl.isRefreshing) {
            refreshControl.endRefreshing()
        }
    }

    private func updateFiltered() {
        filtered = clients.where({ $0.needShow }).where({ $0.sex == selectedSex })
    }
    private func updateInterface() {

        clientsTable.reloadData()
    }
    private func updateSegmentControl() {

        let females = prepareSegmentTitle("Девушки", with: clients.count({ $0.sex == UserSex.female }))
        let males =  prepareSegmentTitle("Парни", with: clients.count({ $0.sex == UserSex.male }))

        sexSegment.values = [
             (females, UserSex.female),
             (males, UserSex.male)
        ]
        sexSegment.select(selectedSex)
    }
    private func prepareSegmentTitle(_ title: String, with count: Int) -> String {

        if (0 == count) {
            return title
        }
        else {
            return "\(title) \(count)"
        }
    }
}
//MARK: Actions
extension OnePlaceClientsController {
    @IBAction private func goBack() {

        self.navigationController?.popViewController(animated: true)
    }
    private func changeSex(_ segment: UISegmentedControl, index: Int, value: Any ) {

        selectedSex = value as! UserSex
        updateInterface()
    }
}

//MARK: UITableViewDelegate
extension OnePlaceClientsController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//MARK: UITableViewDataSource
extension OnePlaceClientsController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: OnePlaceClientsCell.identifier, for: indexPath) as! OnePlaceClientsCell
        cell.update(data: filtered[indexPath.row])

        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OnePlaceClientsCell.height
    }
}
