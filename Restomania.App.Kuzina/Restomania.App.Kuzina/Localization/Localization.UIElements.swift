//
//  File.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 20.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

extension Localization {
    public class UIElements {

        private static let tableName = "UIElements"
        private static let space = "\(String.tag(UIElements.self))"

        public class RefreshControl {

            private static let space = "\(UIElements.space).\(String.tag(RefreshControl.self))"

            public static let title = "\(space).Title".localized(tableName: tableName)
        }
    }
}
