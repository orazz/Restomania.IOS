//
//  Cart.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class Cart: Reservation {

    private let _place: PlaceCartContainer

    internal init(place: PlaceCartContainer, cart: CommonCartContainer, saver: @escaping () -> Void) {
        _place = place

        super.init(cart: cart, saver: saver)

        while( 0 != _place.dishes.filter({ 0 == $0.Count }).count) {

            for (index, dish) in _place.dishes.enumerated() {
                if (dish.Count == 0) {

                    _place.dishes.remove(at: index)
                    break
                }
            }
        }
    }

    //Properties
    public var placeID: Long {
        return _place.placeID
    }
    public var dishes: [OrderedDish] {
        return _place.dishes.where({$0.Count > 0}).map({ OrderedDish(source: $0) })
    }
    public var takeaway: Bool {
        get {
            return _place.takeaway
        }
        set {
            _place.takeaway = newValue
            save()
        }
    }
    public var comment: String {
        get {
            return _place.comment
        }
        set {
            _place.comment = newValue
            save()
        }
    }
    public var totalPrice: Double {

        var result = Double(0)

        for dish in dishes {

            result += dish.Cost
        }

        return result
    }
    public var hasDishes: Bool {
        return !dishes.isEmpty
    }

    //Build order for adding
    public func build(cardID: Long) -> AddingOrder {

        let result = AddingOrder()

        result.PlaceID = placeID
        result.Dishes = dishes
        result.CompleteDate = dateTime
        result.CardID = cardID
        result.TakeAway = takeaway
        result.Comment = comment
        result.PersonCount = persons

        return result
    }

    //Methods
    public func add(dish: Dish, count: Int = 1) {

        var newCount = count
        if let ordered = find(dish) {

            newCount += ordered.Count
        }

        //Set
        if let ordered = find(dish) {
            ordered.Count = newCount
        } else {
            _place.dishes.append(OrderedDish(dish, count: count))
        }

        save()
    }
    public func remove(dishID: Long) {

        for (index, ordered) in dishes.enumerated() {
            if (dishID == ordered.DishID) {

                _place.dishes.remove(at: index)
                break
            }
        }

        save()
    }
    public func refresh(dishes menuDishes: Array<Dish>) {

        //Update name and price
        for dish in menuDishes {
            if let ordered = find(dish) {

                ordered.Price = dish.price
                ordered.Name = dish.name
            }
        }

        //Prepare for remove
        var ids = [Long]()
        for ordered in dishes {
            if (nil == menuDishes.find({ ordered.DishID == $0.ID })) {

                ids.append(ordered.DishID)
            }
        }
        //Remove
        for dishID in ids {
            for (index, dish) in dishes.enumerated() {
                if dishID == dish.DishID {

                    _place.dishes.remove(at: index)
                    break
                }
            }
        }

        save()
    }
    public override func clear() {

        _place.takeaway = false
        _place.comment = String.empty
        _place.dishes.removeAll()

        super.clear()
    }

    private func find(_ dish: Dish) -> OrderedDish? {
        return find(dish.ID)
    }
    private func find(_ dishID: Long) -> OrderedDish? {
        return _place.dishes.find({ dishID == $0.DishID })
    }
}
