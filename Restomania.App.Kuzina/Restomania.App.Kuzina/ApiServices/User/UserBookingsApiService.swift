//
//  UserBookingsApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class UserBookingsApiService: BaseAuthApiService {

    public init(storage: IKeysStorage) {
        super.init(storage: storage, rights: .User, area: "User/BookingOrders", tag: "UserBookingsApiService")
    }

    public func All(args: GetArgs? = nil) -> RequestResult<[Booking]> {
        let parameters = CollectParameters([
                "time": args?.time
            ])

        return _client.GetRange(action: "All", type: Booking.self, parameters: parameters)
    }
    public func Find(orderID: Int64) -> RequestResult<Booking> {
        let parameters = CollectParameters([
                "elementID": orderID
            ])

        return _client.Get(action: "Find", type: Booking.self, parameters: parameters)
    }
    public func Add(booking: AddingBooking) -> RequestResult<Booking> {
        let parameters = CollectParameters([
                "placeID": booking.PlaceID,
                "completeDate": booking.CompleteDate,
                "comment": booking.Comment,
                "personCount": booking.PersonCount
            ])

        return _client.Post(action: "Add", type: Booking.self, parameters: parameters)
    }
    public func Cancel(bookingID: Int64) -> RequestResult<Booking> {
        let parameters = CollectParameters([
                "elementID": bookingID
            ])

        return _client.Put(action: "Cancel", type: Booking.self, parameters: parameters)
    }
}
