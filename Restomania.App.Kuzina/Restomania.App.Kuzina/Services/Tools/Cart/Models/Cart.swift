//
//  CartService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public protocol CartUpdateProtocol {
    func cart(_ cart: CartService, changedDish dishId: Long, newCount: Int)
    func cart(_ cart: CartService, removedDish dishId: Long)
}
public class CartService: Reservation {

    private let place: PlaceCartContainer
    private let eventsAdapter: EventsAdapter<CartUpdateProtocol>
    private let cartQueue = DispatchQueue(label: Guid.new)

    internal init(place: PlaceCartContainer, cart: CommonCartContainer, saver: @escaping () -> Void) {

        self.place = place
        self.eventsAdapter = EventsAdapter(tag: "\(String.tag(CartService.self))#\(place.placeId)")

        super.init(cart: cart, saver: saver)

        while (true) {
            guard let index = self.place.dishes.index(where: { $0.count == 0 }) else {
                break
            }

            self.place.dishes.remove(at: index)
        }
    }

    //Tools
    public var placeId: Long {
        return place.placeId
    }
    public var isEmpty: Bool {
        return place.dishes.notAny({ $0.count > 0 })
    }
    public var hasDishes: Bool {
        return place.dishes.any({ $0.count > 0 })
    }
    public var dishesCount: Int {
        return place.dishes.count({ $0.count > 0 })
    }
    public var dishes: [AddedOrderDish] {
        return place.dishes.where({$0.count > 0}).map({ AddedOrderDish(source: $0) })
    }

    //Properties
    public var takeaway: Bool {
        get {
            return place.takeaway
        }
        set {
            place.takeaway = newValue
            save()
        }
    }
    public var comment: String {
        get {
            return place.comment
        }
        set {
            place.comment = newValue
            save()
        }
    }

    //Methods
    public func total(with menu: MenuSummary) -> Price {

        var result = Price.zero

        for dish in dishes {
            result = result + dish.total(with: menu)
        }

        return result
    }

    public func add(dishId: Long, with addings: [Long], use variationId: Long? = nil) {

//        var newCount = count
//        if let ordered = find(dishId) {
//            ordered.count += count
//            newCount = ordered.count
//        } else {
//            place.dishes.append(AddedOrderDish(dishId: dishId, count: count))
//        }

        trigger({ $0.cart(self, changedDish: dishId, newCount: newCount)})

        save()
    }
    public func increment(_ dish: AddedOrderDish) {

    }
    public func decrement(_ dish: AddedOrderDish) {

    }

    public func build(cardId: Long) -> AddedOrder {

        let result = AddedOrder()

        result.placeId = placeId
        result.cardId = cardId
        result.dishes = dishes
        result.completeAt = buildCompleteAt()
        result.comment = comment
        result.takeaway = takeaway

        return result
    }
    private func trigger(_ action: @escaping ((CartUpdateProtocol) -> Void)) {
        cartQueue.async {
            self.eventsAdapter.invoke(action)
        }
    }
    public override func clear() {

        place.takeaway = false
        place.comment = String.empty
        place.dishes.removeAll()

        super.clear()
    }

    public func find(_ dish: Dish) -> AddedOrderDish? {
        return find(dish.ID)
    }
    public func find(_ dishID: Long) -> AddedOrderDish? {
        return place.dishes.find({ dishID == $0.dishId })
    }
}
extension CartService: IEventsEmitter {
    public typealias THandler = CartUpdateProtocol

    public func subscribe(guid: String, handler: CartService.THandler, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}
