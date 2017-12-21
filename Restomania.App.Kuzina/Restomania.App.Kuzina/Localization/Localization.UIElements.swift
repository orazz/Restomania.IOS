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
            private static let space = "\(String.tag(RefreshControl.self))"

            public static let title = "\(space).Title".localized(tableName: tableName)
        }
        public class ProblemAlerts {
            private static let space = "\(String.tag(ProblemAlerts.self))"

            public static let okAction = "\(space).OK".localized(tableName: tableName)
            public static let errorTitle = "\(space).ErrorTitle".localized(tableName: tableName)
            public static let connectionErrorTitle = "\(space).ConnectionErrorTitle".localized(tableName: tableName)
            public static let noConnectionMessage = "\(space).NoConnectionMessage".localized(tableName: tableName)
            public static let serverErrorMessage = "\(space).ServerErrorMessage".localized(tableName: tableName)
        }
        public class Schedule {
            private static let space = "\(String.tag(Schedule.self))"

            public static let holiday = "\(space).Holiday".localized(tableName: tableName)
        }
    }
}
extension String {
    public func extendSpace(by type: Any.Type) -> String {
        return self.extendSpace(by: String.tag(type))
    }
    public func extendSpace(by area: String) -> String {
        return "\(self).\(area)"
    }

}
