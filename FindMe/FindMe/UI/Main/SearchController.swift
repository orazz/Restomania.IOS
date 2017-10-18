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


public class SearchController: UIViewController {

    //MARK: UI Elements
    @IBOutlet public weak var SegmentControl: UISegmentedControl!
    @IBOutlet public weak var Searchbar: UISearchBar!
    @IBOutlet public weak var TableView: UITableView!
    private var _loader: InterfaceLoader!


    //MARK: Data & Services
    private var _listAdapter: PlacesListAdapter!
    private var _tableAdapter: PlacesListTableAdapter!
    private var _cache: SearchPlaceCardsCacheService!
    private var _likesService: LikesService!
    private var _stored: [SearchPlaceCard]! {
        didSet {
            _tableAdapter.update(places: _stored)
        }
    }


    //MARK: View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)
        SegmentControl.addTarget(self, action: #selector(updateSegment), for: .valueChanged)

        _listAdapter = PlacesListAdapter(source: self)
        _tableAdapter = PlacesListTableAdapter(source: TableView, delegate: _listAdapter)
        Searchbar.delegate = _tableAdapter
        _cache = ServicesFactory.shared.searchCards
        _likesService = ServicesFactory.shared.likes

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
    }

    //MARK: Load data
    private func loadData() {

        let local = _cache.allLocal
        if (local.isEmpty) {
            _loader.show()

            _stored = []
        }
        else {
            _stored = local
        }

        let task = _cache.all()
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self._loader.hide()

                if let response = response {
                    
                    self._stored = response
                }
                else if (self._stored.isEmpty) {

                    let alert = UIAlertController(title: "Ошибка", message: "Возникла ошибка при обновлении данных. Проверьте подключение к интернету или повторите позднее.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                }
            }
        })
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
