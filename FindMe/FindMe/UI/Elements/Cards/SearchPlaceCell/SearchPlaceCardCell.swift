//
//  SearchPlaceCardCell.swift
//  FindMe
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class SearchPlaceCardCell: UITableViewCell {

    //MARK: Cell properties
    private static let identifier = Guid.new
    private static let nibName = "SearchPlaceCardCellView"
    public static let height = CGFloat(75)

    public static func register(in tableview: UITableView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        tableview.register(nib, forCellReuseIdentifier: identifier)
    }

    //MARK: UIElements

    //MARK: Data
    private let _likes: LikesService
    private let _position: PositionService
    private var _source: SearchPlaceCard

    //MARK: Constructors
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        _likes = ServicesFactory.shared.likes
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        _likes = ServicesFactory.shared.likes
//        fatalError("init(coder:) has not been implemented in \(String.tag(SearchPlaceCardCell.self))")
    }



    public func setup(card: SearchPlaceCard) {

        _source = card
    }

}
