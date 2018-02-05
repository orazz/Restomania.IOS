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

public protocol OnePlaceClientsControllerDelegate {
    func writeMessageTo(_ userId: Long)
}
public class OnePlaceClientsController: UIViewController {

    private static let nibName = "OnePlaceClientsView"
    public static func build(for sex: UserSex, in place: DisplayPlaceInfo) -> OnePlaceClientsController {

        let vc = OnePlaceClientsController(nibName: nibName, bundle: Bundle.main)

        vc.place = place
        vc.selectedSex = sex
        vc.apiClient = ApiServices.Places.clients
        vc.currentUserId = ToolsServices.shared.keys.keys(for: .user)?.id ?? -1

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
    private var currentUserId: Long!
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
        refreshControl = clientsTable.addRefreshControl(target: self, selector: #selector(needRefreshData))
        OnePlaceClientsCell.register(in: clientsTable)

        updateSegmentControl()
        sexSegment.onChangeEvent = changeSex(_:index:value:)

        self.navigationController?.navigationBar.backgroundColor = ThemeSettings.Colors.background
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
        refreshControl.endRefreshing()
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
extension OnePlaceClientsController: OnePlaceClientsControllerDelegate {
    @IBAction private func goBack() {

        self.navigationController?.popViewController(animated: true)
    }
    private func changeSex(_ segment: UISegmentedControl, index: Int, value: Any ) {

        selectedSex = value as! UserSex
        updateInterface()
    }
    public func writeMessageTo(_ userId: Long) {

        Log.debug(tag, "Try write message to user #\(userId).")

        let tabs = TabBarController.instance!
        let chat = tabs.chat
        if let dialog = chat.dialog(with: userId),
            let dialogController = chat.controllerFor(dialogId: dialog.ID),
            let navigator = self.navigationController {
            DispatchQueue.main.async {

                var history: [UIViewController] = []
                for vc in navigator.viewControllers {
                    history.append(vc)
                    if (tabs === vc) {
                        break
                    }
                }
                history.append(dialogController)

                navigator.setViewControllers(history, animated: true)
                tabs.focusOn(.chat)
            }

            return
        }


        Log.info(tag, "Create new dialogs with user #\(userId)")
        loader.show()
        let request = chat.start(with: userId)
        request.async(.background, completion: { response in

            if (response.isSuccess) {
                self.writeMessageTo(userId)
            }
            else {
                DispatchQueue.main.async {

                    self.loader.hide()

                    let alert = ProblemAlerts.Error(for: response.statusCode)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}

//MARK: UITableViewDelegate
extension OnePlaceClientsController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? OnePlaceClientsCell,
            cell.allowMessages {
            writeMessageTo(cell.userId)
        }
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

        let update = filtered[indexPath.row]
        cell.update(by: update, allowMessages: currentUserId != update.ID)

        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OnePlaceClientsCell.height
    }
}
