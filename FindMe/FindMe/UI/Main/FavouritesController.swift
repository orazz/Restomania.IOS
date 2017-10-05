//
//  FavouritesController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import AsyncTask

public class FavouritesController: UIViewController {

    //MARK: UI Elements
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

    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
    }
}
