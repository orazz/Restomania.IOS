//
//  CartService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class CartService {

    private let _tag = String.tag(CartService.self)

    private let file: FSOneFileClient
    private let loadQueue: DispatchQueue

    private var _cartContainer = CommonCartContainer()
    private var _carts = [Cart]()
    private var needSave = false
    private var saveTimer: Timer!
    private var needSaveTrigger: Trigger!

     public init() {

        file = FSOneFileClient(filename: "cart.json", inCache: false, tag: _tag)
        loadQueue = DispatchQueue(label: _tag)

        saveTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkNeedSave), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(checkNeedSave), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        needSaveTrigger = {
            self.needSave = true
        }

        load()
        Log.info(_tag, "Complete load service.")
    }

    public func reservation() -> Reservation {
        return Reservation(cart: _cartContainer, saver: needSaveTrigger)
    }
    public func get(for place: Long) -> Cart {

        if let cart = _carts.find({ place == $0.placeID }) {
            return cart
        }

        let place = PlaceCartContainer(placeID: place)
        _cartContainer.places.append(place)
        let cart = Cart(place: place, cart: _cartContainer, saver: needSaveTrigger)
        _carts.append(cart)

        return cart
    }
    public func clear() {

        _cartContainer.clear()

        for cart in _carts {
            cart.clear()
        }
        _carts.removeAll()

        needSaveTrigger()
    }

    @objc private func checkNeedSave() {
        if (needSave) {
            save()
        }
    }
    private func save() {

        loadQueue.async {
            do {

                let data = try JSONSerialization.data(withJSONObject: self._cartContainer.toJSON()!, options: [])
                self.file.save(data: data)
                self.needSave = false

                Log.debug(self._tag, "Save cart's data to storage.")
            } catch {
                Log.error(self._tag, "Problem with save cart to storage.")
                Log.error(self._tag, "Error: \(error)")
            }

        }
    }
    private func load() {

        loadQueue.sync {

            do {
                if (!self.file.isExist) {
                    return
                }

                let content = self.file.loadData()
                let json = try JSONSerialization.jsonObject(with: content!, options: []) as! JSON

                self._cartContainer = CommonCartContainer(json: json)!
                for place in self._cartContainer.places {
                    self._carts.append(Cart(place: place, cart: self._cartContainer, saver: self.needSaveTrigger))
                }
                Log.debug(self._tag, "Load cart's data from storage")
            } catch {
                Log.warning(self._tag, "Problem with load cart from storage.")
                Log.warning(self._tag, "Error: \(error)")
            }

        }
    }
}
