//
//  KeyValueStorage.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class PropertiesStorage {
    private static let _tag = "PropertiesStorage"
    private static let _storage = UserDefaults.standard

    public class func hasValue(_ key: PropertiesKey) -> Bool {
        let name = build(key)

        return nil != _storage.value(forKey: name)
    }
    public class func remove(_ key: PropertiesKey) {
        let name = build(key)

        _storage.removeObject(forKey: name)
    }

    //Settings
    public class func set(_ key: PropertiesKey, value: String) {
        let name = build(key)

        _storage.set(value, forKey:name)
    }
    public class func set(_ key: PropertiesKey, value: Int) {
        let name = build(key)

        _storage.set(value, forKey: name)
    }
    public class func set(_ key: PropertiesKey, value: Long) {
        let name = build(key)

        _storage.set("\(value)", forKey: name)
    }
    public class func set(_ key: PropertiesKey, value: Float) {
        let name = build(key)

        _storage.set(value, forKey: name)
    }
    public class func set(_ key: PropertiesKey, value: Double) {
        let name = build(key)

        _storage.set(value, forKey: name)
    }
    public class func set(_ key: PropertiesKey, value: Date) {
        let name = build(key)

        _storage.set(value.timeIntervalSince1970, forKey: name)
    }
    public class func set(_ key: PropertiesKey, value: Bool) {
        let name = build(key)

        _storage.set(value, forKey: name)
    }
    public class func set(_ key: PropertiesKey, value: Encodable) {
        let json = value.toJSON()

        if (nil == json) {
            return
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: json!, options: [])

            set(key, value: String(data:data, encoding: .utf8)!)
        } catch {
            Log.Warning(_tag, "Problem with save JSON for \(build(key)).")
        }

    }

    //Getting
    public class func getString(_ key: PropertiesKey) -> OptionalValue<String> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? String

        return OptionalValue(value)
    }
    public class func getInt(_ key: PropertiesKey) -> OptionalValue<Int> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? Int

        return OptionalValue(value)
    }
    public class func getLong(_ key: PropertiesKey) -> OptionalValue<Long> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? String

        if (nil == value) {
            return OptionalValue(nil)
        }

        return OptionalValue(Long(value!))
    }
    public class func getFloat(_ key: PropertiesKey) -> OptionalValue<Float> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? Float

        return OptionalValue(value)
    }
    public class func getDouble(_ key: PropertiesKey) -> OptionalValue<Double> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? Double

        return OptionalValue(value)
    }
    public class func getDate(_ key: PropertiesKey) -> OptionalValue<Date> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? TimeInterval

        if (nil == value) {
            return OptionalValue(nil)
        }

        return OptionalValue( Date(timeIntervalSince1970: value!))
    }
    public class func getBool(_ key: PropertiesKey) -> OptionalValue<Bool> {
        let name = build(key)
        let value = _storage.value(forKey: name) as? Bool

        return OptionalValue(value)
    }
    public class func get<T: Decodable>(_ type: T.Type, key: PropertiesKey) -> OptionalValue<T> {

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

    private class func build(_ key: PropertiesKey) -> String {
        return "res-storage-key-\(key)"
    }
}
