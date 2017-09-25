//
//  PropertiesKey.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum PropertiesKey: Int {
    
    //App versioning
    case appVersion = 1
    case appBuild = 2
    
    //Refresh and update
    case placesRefreshPeriod = 3
    case clientsDataRefreshPeriod = 4
    case updateCheckInPeriod = 5
    
    
    case pushDeviceToken = 6
}
