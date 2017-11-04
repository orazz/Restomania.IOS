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
    public static func build(for place: Place) -> OnePlaceClientsController {

        let vc = OnePlaceClientsController(nibName: nibName, bundle: Bundle.main)

        vc._place = place
        vc._apiClient = ApiServices.Places.clients

        return vc
    }

    //MARK: UI elements
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var segmentControl: FMSegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    private var _loader: InterfaceLoader!

    //MARK: Data & services
    private var _tag = String.tag(OnePlaceClientsController.self)
    private var _clients: [PlaceClient] = []
    private var _filtered: [PlaceClient] = []
    private var _place: Place!
    private var _apiClient: PlacesClientsApiService!

    //MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupMarkup()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadData()
    }
    private func setupMarkup() {

        _loader = InterfaceLoader(for: self.view)
        _loader.show()

        navigationBar.topItem?.title = _place.name
        segmentControl.values = [
            "Девушки": UserSex.female,
            "Парни": UserSex.male
        ]
        segmentControl.onChangeEvent = changeSex(_:index:value:)

        OnePlaceClientsCell.register(in: tableView)
    }
    private func loadData() {

        _loader?.show()

        let request = _apiClient.all(in: _place.ID)
        request.async(.background, completion: { response in

            DispatchQueue.main.async {
                if (response.isSuccess) {

                    self._clients = response.data!
                    self.reload()
                }
                else {
                    Log.Warning(self._tag, "Problem with getting clients data.")

                    if (response.statusCode == .ConnectionError) {

                        let alert = UIAlertController(title: "Ошибка соединения", message: "Нет содинения с интрнетом. Попробуйте позднее.", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

                        self.show(alert, sender: nil)
                    }
                }

                self._loader?.hide()
            }
        })
    }

    private func reload() {

        let sex = segmentControl.value as! UserSex
        _filtered = _clients.where({ $0.needShow }).where({ $0.sex == sex })

        tableView.reloadData()
    }

    //MARK: Actions and handlers
    @IBAction private func goBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    private func changeSex(_ segment: UISegmentedControl, index: Int, value: Any ) {
        reload()
    }
}

//MARK: UITableViewDelegate
extension OnePlaceClientsController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension OnePlaceClientsController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _filtered.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: OnePlaceClientsCell.identifier, for: indexPath) as! OnePlaceClientsCell
        cell.update(data: _filtered[indexPath.row])

        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OnePlaceClientsCell.height
    }
}
