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

    private let _tag: String = "CartService"

    private let _filename: String = "cart.json"
    private let _fileSystem: FileSystem
    private let _queue: DispatchQueue

    private var _cartContainer: CommonCartContainer
    private var _carts: [Cart]
    private var _saver: (() -> Void)!

     public init() {

        _fileSystem = FileSystem()
        _queue = DispatchQueue(label: _tag)

        _cartContainer = CommonCartContainer()
        _carts = [Cart]()
        _saver = { self.save() }

        load()
        Log.Info(_tag, "Complete load service.")
    }

    public func reservation() -> Reservation {
        return Reservation(cart: _cartContainer, saver: _saver)
    }
    public func cart(placeID: Long) -> Cart {

        if let cart = _carts.find({ placeID == $0.placeID }) {
            return cart
        }

        let place = PlaceCartContainer(placeID: placeID)
        _cartContainer.places.append(place)
        let cart = Cart(place: place, cart: _cartContainer, saver: _saver)
        _carts.append(cart)

        return cart
    }
    public func clear() {

        _cartContainer.clear()

        for cart in _carts {
            cart.clear()
        }
        _carts.removeAll()

        save()
    }

    private func save() {

        _queue.async {

            do {

                let data = try JSONSerialization.data(withJSONObject: self._cartContainer.toJSON()!, options: [])
                self._fileSystem.saveTo(self._filename, data: data, toCache: false)

                Log.Debug(self._tag, "Save cart's data to storage.")
            } catch {
                Log.Error(self._tag, "Problem with save cart to storage.")
                Log.Error(self._tag, "Error: \(error)")
            }

        }
    }
    private func load() {

        _queue.sync {

            do {
                if (!self._fileSystem.isExist(_filename, inCache: false)) {
                    return
                }

                let content = self._fileSystem.load(self._filename, fromCache: false)!
                let json = try JSONSerialization.jsonObject(with: content.data(using: .utf8)!, options: []) as! JSON

                self._cartContainer = CommonCartContainer(json: json)!
                for place in self._cartContainer.places {
                    self._carts.append(Cart(place: place, cart: self._cartContainer, saver: self._saver))
                }
                Log.Debug(self._tag, "Load cart's data from storage")
            } catch {
                Log.Warning(self._tag, "Problem with load cart from storage.")
                Log.Warning(self._tag, "Error: \(error)")
            }

        }
    }
}
