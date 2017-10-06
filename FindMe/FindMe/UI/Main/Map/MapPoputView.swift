//
//  MapPoputView.swift
//  FindMe
//
//  Created by Алексей on 07.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class MapPopupView: UIView {

    private static let nibName = "MapPopupView"
    private static let height = CGFloat(155)
    public static func build(parent: UIView, delegate: PlacesListDelegate) -> MapPopupView {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! MapPopupView

        instance._parent = parent
        instance._delegate = delegate

        instance.initialize()

        return instance
    }

    //MARK: UI elements
    @IBOutlet public var TableView: UITableView!
    private var _parent: UIView!

    //MARK: Data and services
    private var _delegate: PlacesListDelegate!
    private var _card: SearchPlaceCard? = nil
    private var _isOpen: Bool = false

    private func initialize() {

        TableView.delegate = self
        TableView.dataSource = self

        SearchPlaceCardCell.register(in: TableView)

        let parent = _parent.frame
        self.frame = CGRect(x: 0,
                            y: parent.height - 49, //49 is height of tabbar
                            width: parent.width,
                            height: MapPopupView.height)
        _parent.addSubview(self)
    }


    //MARK: Actions
    public func update(by card: SearchPlaceCard){

        _card = card
        TableView.reloadData()
    }
    public func open() {

        if (_isOpen) {
            return
        }
        _isOpen = true

        moveTop(different: MapPopupView.height)
    }
    @IBAction public func close() {

        if (!_isOpen) {
            return
        }
        _isOpen = false

        moveTop(different: -MapPopupView.height)
    }
    private func moveTop(different: CGFloat) {

        let source = self.frame

        UIView.animate(withDuration: 0.3, animations: {

            self.frame = CGRect(x: source.origin.x,
                                y: source.origin.y - different,
                                width: source.width,
                                height: source.height)
        })
    }
}
extension MapPopupView: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let card = _card {
            _delegate.goTo(place: card.ID)
        }
    }
}
extension MapPopupView: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let _ = _card {
            return 1
        }
        else {
            return 0
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPlaceCardCell.identifier, for: indexPath) as! SearchPlaceCardCell

        cell.setup(card: _card!, delegate: _delegate)

        return cell
    }
}
