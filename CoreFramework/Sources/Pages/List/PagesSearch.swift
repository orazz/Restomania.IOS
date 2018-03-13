//
//  PagesSearch.swift
//  PagesSearch
//
//  Created by Алексей on 09.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class PagesSearch {

    public static func registerTemplates() {

        let bundle = Bundle.coreFramework
        let store = TemplateStore.shared

        store.searchPlaceCard(name: String.tag(SearchPlaceCard.self), from: bundle)
    }
}
