//
//  MapPopupView.swift
//  CoreFramework
//
//  Created by Oraz Atakishiyev on 6/21/18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

class MapPopupView: UIView {

    private static let height = CGFloat(150)
    
    //MARK: UI elements
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    private var loadNextIndicator: UIActivityIndicatorView!
    private var offsetConstraint: NSLayoutConstraint? = nil
    
    //Service
    //private let searchService = CacheServices.search
    
    //MARK: Data and services
    private let nibName = String.tag(MapPopupView.self)
   // private var delegate: PlacesListDelegate? = nil
    private var card: SearchPlaceCard? = nil
    private var isOpen: Bool = false
    //private let loadQueue = AsyncQueue.createForControllerLoad(for: String.tag(MapPopupView.self))
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.setContraint(height: CGFloat(MapPopupView.height))
        
        
        //tableView.delegate = self
        //tableView.dataSource = self
        //SearchPlaceCardCell.register(in: tableView)
        
        loadNextIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        //loadNextIndicator.color = ThemeSettings.Colors.bullet
        loadNextIndicator.startAnimating()
        loadNextIndicator.hidesWhenStopped = true
        loadNextIndicator.frame = CGRect(x: 0, y: 0, width: loadNextIndicator.frame.width, height: 100)
        tableView.tableFooterView = loadNextIndicator
    }
    
//    public func setup(offset: NSLayoutConstraint, delegate: PlacesListDelegate) {
//
//        self.offsetConstraint = offset
//        self.delegate = delegate
//    }
    
    //MARK: Actions
    public func update(by placeId: Long){
        
//        if let card = searchService.cache.find(placeId) {
//            self.card = card
//        }
//        else {
//            self.card = nil
//            requestSearchCard(placeId)
//        }
        
        reload()
    }
    private func requestSearchCard(_ placeId: Long) {
        
//        let request = searchService.find(placeId)
//        request.async(loadQueue) { response in
//            DispatchQueue.main.async {
//
//                if let card = response.data {
//                    self.card = card
//                    self.reload()
//                }
//
//                if (response.isFail) {
//                    let alert = ProblemAlerts.Error(for: response.statusCode)
//                    Router.shared.navigator.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
    }
    private func reload() {
        tableView.reloadData()
        
        if (nil == card) {
            loadNextIndicator.startAnimating()
        }
        else {
            loadNextIndicator.stopAnimating()
        }
    }
    public func open() {
        
        if (isOpen) {
            return
        }
        isOpen = true
        
        setupOffset(hide: false)
    }
    @IBAction public func close() {
        
        if (!isOpen) {
            return
        }
        isOpen = false
        
        card = nil
        reload()
        
        loadNextIndicator.stopAnimating()
        setupOffset(hide: true)
    }
    private func setupOffset(hide: Bool) {
        
        //        let barHeight = Router.shared.tabs.tabBar.frame.height
        let offset = hide ? MapPopupView.height : 0
        offsetConstraint?.constant = offset
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
}
extension MapPopupView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let card = card {
            //delegate?.goTo(place: card.id)
        }
    }
}
extension MapPopupView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nil == card ? 0 : 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPlaceCardCell.identifier, for: indexPath) as! SearchPlaceCardCell
//
//        cell.update(card: card!, delegate: delegate)
        
        return UITableViewCell()//cell
    }
}
