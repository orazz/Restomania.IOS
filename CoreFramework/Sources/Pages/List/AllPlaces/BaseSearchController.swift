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

    //UI
    internal var searchBar: UISearchBar?

    //Services
    internal let themeColors = DependencyResolver.get(ThemeColors.self)

    //Data
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
        tableView.keyboardDismissMode = .onDrag
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        cardTemplate.register(in: tableView)

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        showNavigationBar()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }
    private func showNavigationBar() {
//        self.navigationController?.navigationBar.topItem?.titleView = searchBar
//        self.navigationController?.setStatusBarStyle(from: themeColors.statusBarOnNavigation)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    internal func update(by places:[PlaceSummary]) {

        self.places = sort(places)
        tableView.reloadData()
    }
    private func sort(_ places: [PlaceSummary]) -> [PlaceSummary] {

        if let lastPosition = PositionsService.shared.lastPosition {

            let points = places.map({ (summary: $0, point: PositionsService.Position(lat: $0.Location.latitude, lng: $0.Location.longitude)) })
            
            let normal = points.where({ !$0.point.isEmpty })
                                .map({ (summary: $0.summary, distance: $0.point.distance(to: lastPosition)) })
                                .sorted(by: { $0.distance < $1.distance })
                                .map({ $0.summary })

            let rest = points.where({ $0.point.isEmpty })
                                .sorted(by: { $0.summary.Name < $1.summary.Name })
                                .map({ $0.summary })

            return normal + rest
        }
        else {
            return places.sorted(by: { $0.Name < $1.Name })
        }
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
