//
//  SearchController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary


public class SearchController: UIViewController, UISearchBarDelegate {

    //MARK: UI Elements
    @IBOutlet public weak var SegmentControl: UISegmentedControl!
    @IBOutlet public weak var Searchbar: UISearchBar!
    @IBOutlet public weak var TableView: UITableView!
    private weak var _loader: InterfaceLoader!


    //MARK: Data & Services
    private var _stored: [SearchPlaceCard] = []
    private var _listAdapter: PlacesListAdapter!
    private var _tableAdapter: PlacesListTableAdapter!
    private var _likesService: LikesService!


    //MARK: View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)

        _listAdapter = PlacesListAdapter(source: self)
        _tableAdapter = PlacesListTableAdapter(source: TableView, delegate: _listAdapter)
        Searchbar.delegate = _tableAdapter
        _likesService = ServicesFactory.shared.likes

        SegmentControl.addTarget(self, action: #selector(updateSegment), for: .touchUpInside)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
    }

    //MARK: UISegmentedControl
    @objc private func updateSegment() {

        switch SegmentControl.selectedSegmentIndex {
            case 1:
                let liked = _likesService.all()
                _tableAdapter.update(places: _stored.where({ liked.contains($0.ID) }))

            default:
                return _tableAdapter.update(places: _stored)
        }
    }
}
