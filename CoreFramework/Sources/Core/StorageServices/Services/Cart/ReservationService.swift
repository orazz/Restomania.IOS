//
//  ReservationService.swift
//  CoreFramework
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class ReservationService {

    private let _cart: CommonCartContainer
    private let _saver: () -> Void

    internal init(cart: CommonCartContainer, saver: @escaping () -> Void ) {

        self._cart = cart
        self._saver = saver
    }

    public func buildCompleteAt() -> Date {

        let calendar = Calendar.utcCurrent
        var components = DateComponents()

        //Date
        components.year = calendar.component(.year, from: date)
        components.month = calendar.component(.month, from: date)
        components.day = calendar.component(.day, from: date)

        //Time
        components.hour = calendar.component(.hour, from: time)
        components.minute = calendar.component(.minute, from: time)
        components.second = 0

        return calendar.date(from: components)!
    }
    public var date: Date {
        get {
            return _cart.date
        }
        set {
            _cart.date = newValue
            save()
        }
    }
    public var time: Date {
        get {
            return _cart.time
        }
        set {
            _cart.time = newValue
            save()
        }
    }
    public var persons: Int {
        get {
            return _cart.persons
        }
        set {
            _cart.persons = newValue
            save()
        }
    }

    public func clear() {

        _cart.clear()
        save()
    }
    internal func save() {

        _saver()
    }
}
