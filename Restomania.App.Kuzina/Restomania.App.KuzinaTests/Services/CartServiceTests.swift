//
//  CartServiceTests.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 25.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import XCTest
@testable import RestomaniaAppKuzina

public class CartServiceTests: XCTestCase {

    private var _service: CartService!

    public override func setUp() {
        super.setUp()

        _service = CartService()
        _service.clear()
    }

    public func testReservation() {

        let reservation = _service.reservation()

        reservation.date = Date.parseJson(value: "2017-07-21T00:00:00Z")
        reservation.time = Date.parseJson(value: "2016-04-01T12:22:00Z")
        reservation.persons = 13

        let newService = CartService()
        let newReservation = newService.reservation()
        XCTAssertEqual("2017-07-21T12:22:00Z", newReservation.dateTime.prepareForJson())
        XCTAssertEqual(13, newReservation.persons)
    }

    public func testCart() {

        //Prepare
        let dish1 = Dish()
        dish1.ID = 123
        dish1.Price = 23.5

        let dish2 = Dish()
        dish2.ID = 11
        dish2.Price = 10.0

        let dish3 = Dish()
        dish3.ID = 4
        dish3.Price = 5.0

        //Initialize
        _ = _service.cart(placeID: 12)
        let cart = _service.cart(placeID: 12)
        cart.date = Date.parseJson(value: "2017-07-21T00:00:00Z")
        cart.time = Date.parseJson(value: "2016-04-01T12:22:00Z")
        cart.persons = 13
        cart.takeaway = true
        cart.comment = "test"

        //Process
        //Add dishes
        XCTAssertEqual(Double(0), cart.totalPrice)
        XCTAssertFalse(cart.hasDishes)
        XCTAssertEqual(0, cart.dishes.count)
        cart.add(dish: dish1, count: 2)
        cart.add(dish: dish2)
        XCTAssertEqual(57.0, cart.totalPrice)
        XCTAssertTrue(cart.hasDishes)
        XCTAssertEqual(2, cart.dishes.count)

        //Remove
        cart.remove(dishID: dish2.ID)
        cart.remove(dishID: dish3.ID)
        XCTAssertEqual(47.0, cart.totalPrice)
        XCTAssertEqual(1, cart.dishes.count)

        //Refresh
        cart.add(dish: dish2)
        cart.add(dish: dish3)
        XCTAssertEqual(3, cart.dishes.count)
        XCTAssertEqual(62.0, cart.totalPrice)
        cart.refresh(dishes: [dish1, dish3])
        XCTAssertEqual(2, cart.dishes.count)
        XCTAssertEqual(52.0, cart.totalPrice)

        sleep(3)
        let queue = DispatchQueue(label: "CartService")
        queue.sync {
            print("show")
        }

        //Reload
        let newService = CartService()
        let newCart = newService.cart(placeID: 12)
        XCTAssertEqual(12, newCart.placeID)
        XCTAssertEqual(2, newCart.dishes.count)
        XCTAssertNotNil(newCart.dishes.find({ dish1.ID == $0.DishID }))
        XCTAssertNil(newCart.dishes.find({ dish2.ID == $0.DishID }))
        XCTAssertNotNil(newCart.dishes.find({ dish3.ID == $0.DishID }))
        XCTAssertTrue(newCart.takeaway)
        XCTAssertEqual("test", newCart.comment)
        XCTAssertEqual("2017-07-21T12:22:00Z", newCart.dateTime.prepareForJson())
        XCTAssertEqual(13, newCart.persons)

        //Add & remove
        cart.add(dish: dish3, count: -1)
        XCTAssertEqual(1, cart.dishes.count)
        XCTAssertEqual(47.0, cart.totalPrice)
        cart.add(dish: dish1, count: 2)
        XCTAssertEqual(1, cart.dishes.count)
        XCTAssertEqual(94.0, cart.totalPrice)
    }
}
