//
//  TemplateContainer.swift
//  PagesTools
//
//  Created by Алексей on 09.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class TemplateContainer {

    public let name: TemplateName
    public let identifier: String
    public let nibName: String
    public let bundle: Bundle

    public var nib: UINib {

        if let nib = loadedNib {
            return nib
        }

        let nib = UINib(nibName: nibName, bundle: bundle)
        loadedNib = nib

        return nib
    }
    private var loadedNib: UINib?

    public init(for name: TemplateName, by nibName: String, from bundle: Bundle) {

        self.name = name
        self.identifier = Guid.new
        self.nibName = nibName
        self.bundle = bundle

        self.loadedNib = nil
    }
}
extension TemplateContainer {

    public func register(in table: UITableView) {
        table.register(nib, forCellReuseIdentifier: identifier)
    }
    public func register(in collection: UICollectionView) {
        collection.register(nib, forCellWithReuseIdentifier: identifier)
    }
}
