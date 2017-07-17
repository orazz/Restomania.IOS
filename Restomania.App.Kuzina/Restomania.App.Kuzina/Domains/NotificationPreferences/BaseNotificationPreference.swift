//
//  BaseNotificationPreference.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class BaseNotificationPreference : BaseDataType
{
    public var ConnectionMethod: MethodConnection
    public var Login: String
    
    public var CompletePayment: Bool
    
    public var NewBooking: Bool
    public var ChangeBookingStatus: Bool
    
    public var NewOrder: Bool
    public var ChangeOrderStatus: Bool
    
    public var NewReview: Bool
    public var ChangeReview: Bool
    
    
    public override init()
    {
        self.ConnectionMethod = .Email
        self.Login = String.Empty
        
        self.CompletePayment = false
        
        self.NewBooking = false
        self.ChangeBookingStatus = false
        
        self.NewOrder = false
        self.ChangeOrderStatus = false
        
        self.NewReview = false
        self.ChangeReview = false
        
        super.init()
    }
    public required init(json: JSON)
    {
        self.ConnectionMethod = ("ConnectionMethod" <~~ json)!
        self.Login = ("Login" <~~ json)!
        
        self.CompletePayment = ("CompletePayment" <~~ json)!
        
        self.NewBooking = ("NewBooking" <~~ json)!
        self.ChangeBookingStatus = ("ChangeBookingStatus" <~~ json)!
        
        self.NewOrder = ("NewOrder" <~~ json)!
        self.ChangeOrderStatus = ("ChangeOrderStatus" <~~ json)!
        
        self.NewReview = ("NewReview" <~~ json)!
        self.ChangeReview = ("ChangeReview" <~~ json)!
        
        super.init(json: json)
    }
}
