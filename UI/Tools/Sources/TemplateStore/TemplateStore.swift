//
//  TemplateStore.swift
//  PagesTools
//
//  Created by Алексей on 09.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class TemplateStore {

    public static let shared = TemplateStore()

    private var containers: [TemplateContainer]

    private init() {
        containers = []
    }

    public func get(for name: TemplateName) -> TemplateContainer {
        return containers.find({ $0.name == name })!
    }

    //MARK: Register
    public func register(for name: TemplateName, by nib: String, from bundle: Bundle) {

        let container = TemplateContainer(for: name, by: nib, from: bundle)
        if let index = containers.index(where: { $0.name == name }) {
            containers[index] = container
        }
        else {
            containers.append(container)
        }
    }
    public func searchPlaceCard(name: String, from bundle: Bundle) {
        register(for: .searchPlaceCard, by: name, from: bundle)
    }
}
