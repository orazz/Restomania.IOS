//
//  PropertiesStorage.swift
//  IOS Library
//
//  Created by Алексей on 20.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class PropertiesStorage<TKey: RawRepresentable> : NSObject {

    private let _storage: UserDefaults

    public override init() {
        _storage = UserDefaults.standard

        super.init()
    }

    public func hasValue(_ key: TKey) -> Bool {
        let name = build(key)

        return nil != _storage.value(forKey: name)
    }
    public func remove(_ key: TKey) {
        let name = build(key)

        _storage.removeObject(forKey: name)
    }

    //Settings
    public func set(_ key: TKey, value: String) {
        let name = build(key)

        _storage.set(value, forKey:name)
    }
    public func set(_ key: TKey, value: Int) {
        let name = build(key)

        _storage.set(value, forKey: name)
    }
    public func set(_ key: TKey, value: Long) {
        let name = build(key)

        _storage.set("\(value)", forKey: name)
    }
    public func set(_ key: TKey, value: Float) {
        let name = build(key)

        _storage.set(value, forKey: name)
    }
    public func set(_ key: TKey, value: Double) {
        let name = build(key)

        _storage.set(value, forKey: name)
    }
    public func set(_ key: TKey, value: Date) {
        let name = build(key)

        _storage.set(value.timeIntervalSince1970, forKey: name)
    }
    public func set(_ key: TKey, value: Bool) {
        let name = build(key)

        _storage.set(value, forKey: name)
    }
    public func set(_ key: TKey, value: JSONEncodable) {
        let json = value.toJSON()

        if (nil == json) {
            return
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: json!, options: [])

            set(key, value: String(data:data, encoding: .utf8)!)
        } catch {

            Log.warning(tag, "Problem with save JSON for \(build(key)).")
        }

    }

    //Getting
    public func getString(_ key: TKey) -> OptionalValue<String> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? String

        return OptionalValue(value)
    }
    public func getInt(_ key: TKey) -> OptionalValue<Int> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? Int

        return OptionalValue(value)
    }
    public func getLong(_ key: TKey) -> OptionalValue<Long> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? String

        if (nil == value) {
            return OptionalValue(nil)
        }

        return OptionalValue(Long(value!))
    }
    public func getFloat(_ key: TKey) -> OptionalValue<Float> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? Float

        return OptionalValue(value)
    }
    public func getDouble(_ key: TKey) -> OptionalValue<Double> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? Double

        return OptionalValue(value)
    }
    public func getDate(_ key: TKey) -> OptionalValue<Date> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? TimeInterval

        if (nil == value) {
            return OptionalValue(nil)
        }

        return OptionalValue( Date(timeIntervalSince1970: value!))
    }
    public func getBool(_ key: TKey) -> OptionalValue<Bool> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? Bool

        return OptionalValue(value)
    }
    public func get<T: JSONDecodable>(_ type: T.Type, key: TKey) -> OptionalValue<T> {

        let jsonString = getString(key)

        if (!jsonString.hasValue) {
            return OptionalValue(nil)
        }

        do {
            let data = jsonString.value.data(using: .utf8)
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! JSON

            return OptionalValue(T(json: json))
        } catch {
            return OptionalValue(nil)
        }
    }

    private func build(_ key: TKey) -> String {
        return "storage-key-\(key.rawValue)"
    }
}
