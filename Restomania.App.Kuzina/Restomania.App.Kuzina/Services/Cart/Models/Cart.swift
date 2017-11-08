//
//  Cart.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public protocol CartUpdateProtocol {
    func cart(_ cart: Cart, changedDish: Dish, newCount: Int)
    func cart(_ cart: Cart, removedDish: Long)
}
public class Cart: Reservation {

    private let _place: PlaceCartContainer
    private let _adapter: EventsAdapter<CartUpdateProtocol>
    private let _queue = DispatchQueue(label: Guid.new)

    internal init(place: PlaceCartContainer, cart: CommonCartContainer, saver: @escaping () -> Void) {
        _place = place
        _adapter = EventsAdapter(name: "\(String.tag(Cart.self))#\(_place.placeID)")

        super.init(cart: cart, saver: saver)

        while( 0 != _place.dishes.filter({ 0 == $0.count }).count) {

            for (index, dish) in _place.dishes.enumerated() {
                if (dish.count == 0) {

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
    public var isEmpty: Bool {
        return _place.dishes.notAny({ $0.count > 0 })
    }
    public var hasDishes: Bool {
        return _place.dishes.any({ $0.count > 0 })
    }
    public var dishesCount: Int {
        return _place.dishes.count({ $0.count > 0 })
    }
    public var dishes: [AddedOrderDish] {
        return _place.dishes.where({$0.count > 0}).map({ AddedOrderDish(source: $0) })
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
    public func totalPrice(with menu: MenuSummary) -> Double {

        var result = Double(0)

        for ordered in dishes {
            if let dish = menu.dishes.find({ $0.ID == ordered.dishId }) {
                result += dish.price.double * Double(ordered.count)
            }
        }

        return result
    }

    //Build order for adding
    public func build(cardId: Long) -> AddedOrder {

        let result = AddedOrder()

        result.placeId = placeID
        result.cardId = cardId
        result.dishes = dishes
        result.completeAt = buildCompleteDateTime()
        result.comment = comment
        result.takeaway = takeaway

        return result
    }

    //Methods
    public func add(dish: Dish, count: Int = 1) {

        var newCount = count
        if let ordered = find(dish) {

            newCount += ordered.count
        }

        //Set
        if let ordered = find(dish) {
            ordered.count = newCount
        } else {
            _place.dishes.append(AddedOrderDish(dish: dish, count: count))
        }

        _queue.async {
           self._adapter.Trigger(action: { $0.cart(self, changedDish: dish, newCount: newCount)})
        }

        save()
    }
    public func remove(dishID: Long) {

        for (index, ordered) in dishes.enumerated() {
            if (dishID == ordered.dishId) {

                _place.dishes.remove(at: index)
                break
            }
        }

        _queue.async {
            self._adapter.Trigger(action: { $0.cart(self, removedDish: dishID)})
        }

        save()
    }
    public func refresh(dishes menuDishes: Array<Dish>) {

        //Prepare for remove
        var ids = [Long]()
        for ordered in dishes {
            if (nil == menuDishes.find({ ordered.dishId == $0.ID })) {

                ids.append(ordered.dishId)
            }
        }
        //Remove
        for dishID in ids {
            for (index, dish) in dishes.enumerated() {
                if dishID == dish.dishId {

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

    private func find(_ dish: Dish) -> AddedOrderDish? {
        return find(dish.ID)
    }
    private func find(_ dishID: Long) -> AddedOrderDish? {
        return _place.dishes.find({ dishID == $0.dishId })
    }
}
extension Cart: IEventsEmitter {
    public typealias THandler = CartUpdateProtocol

    public func subscribe(guid: String, handler: Cart.THandler, tag: String) {
        _adapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        _adapter.unsubscribe(guid: guid)
    }
}
