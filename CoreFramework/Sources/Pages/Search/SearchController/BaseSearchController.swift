//
//  BaseSearchController.swift
//  CoreFramework
//
//  Created by Алексей on 13.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

internal class BaseSearchController: UITableViewController {

    internal var places = [PlaceSummary]()

    private let cardTemplate = TemplateStore.shared.get(for: .searchPlaceCard)

    internal init(){
        super.init(style: .plain)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        super.loadView()

        tableView.separatorStyle = .none
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        cardTemplate.register(in: tableView)

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    internal func update(by places:[PlaceSummary]) {
        
        self.places = places
        tableView.reloadData()
    }
}
extension BaseSearchController {

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cardTemplate.identifier, for: indexPath as IndexPath) as! SearchPlaceCard
        cell.update(summary: places[indexPath.row])

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
