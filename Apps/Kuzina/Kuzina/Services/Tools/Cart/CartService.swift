//
//  CartService.swift
//  Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class CartService: ReservationService {

    private let place: PlaceCartContainer
    private let eventsAdapter: EventsAdapter<CartServiceDelegate>
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
        return place.dishes.where({$0.count > 0})
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

        let result = Price.zero
        for dish in dishes {
            result += dish.total(with: menu)
        }

        return result
    }

    public func add(dishId: Long, with addings: [Long], use variationId: Long? = nil) {

        if addings.isEmpty,
            let container = place.dishes.find({ $0.dishId == dishId &&
                                                 $0.variationId == variationId &&
                                                 $0.additions.isEmpty &&
                                                 $0.subdishes.isEmpty }) {
            increment(container)
            return
        }

        let dish = AddedOrderDish(dishId: dishId, variationId: variationId, additions: addings)
        place.dishes.append(dish)

        save()
        trigger({ $0.cart(self, change: dish) })
    }
    public func increment(_ dish: AddedOrderDish) {

        dish.increment()

        save()
        trigger({ $0.cart(self, change: dish) })
    }
    public func decrement(_ dish: AddedOrderDish) {

        dish.decrement()

        //Change count
        if (dish.count >= 1) {

            save()
            trigger({ $0.cart(self, change: dish) })
            return
        }

        //Remove
        if let index = place.dishes.index(where: { $0 === dish }) {
            place.dishes.remove(at: index)
        }
        save()
        trigger({ $0.cart(self, remove: dish) })
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
    public override func clear() {
        super.clear()

        place.takeaway = false
        place.comment = String.empty
        place.dishes.removeAll()
    }
//
//    public func find(_ dish: Dish) -> AddedOrderDish? {
//        return find(dish.ID)
//    }
//    public func find(_ dishID: Long) -> AddedOrderDish? {
//        return place.dishes.find({ dishID == $0.dishId })
//    }
}
extension CartService: IEventsEmitter {
    public typealias THandler = CartServiceDelegate

    public func subscribe(guid: String, handler: CartService.THandler, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }

    fileprivate func trigger(_ action: @escaping ((CartServiceDelegate) -> Void)) {
        cartQueue.async {
            self.eventsAdapter.invoke(action)
        }
    }
}
