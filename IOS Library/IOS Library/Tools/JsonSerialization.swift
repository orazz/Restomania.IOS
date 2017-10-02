//
//  JsonSerialization.swift
//  IOSLibrary
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

enum JSONSerializationErrors: Error {

    case invalidConstructor
    case problemWithCast
    case invalidData(Error)
    case invalidSerialization
}
extension JSONSerialization {

    open static func parse<Type: Gloss.Decodable>(data: Data) throws -> Type  {

        var json: JSON
        do {
            json = try JSONSerialization.prepareParse(data: data)
        }
        catch {
            throw error
        }

        if let result = Type.init(json: json) {
            return result
        }
        else {
            throw JSONSerializationErrors.invalidConstructor
        }
    }
    open static func parseRange<Type: Gloss.Decodable>(data: Data) throws -> [Type] {

        var json: [JSON]
        do {
            json = try JSONSerialization.prepareParse(data: data)
        }
        catch {
            throw error
        }

        var result = [Type]()
        for element in json {

            if let inited = Type(json: element) {
                result.append(inited)
            }
            else {
                throw JSONSerializationErrors.invalidConstructor
            }
        }

        return result
    }
    private static func prepareParse<Type>(data: Data) throws -> Type {

        var json: Any
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch {
            throw JSONSerializationErrors.invalidData(error)
        }

        if  let casted = json as? Type {
            return casted
        }
        else {
            throw JSONSerializationErrors.problemWithCast
        }
    }

    open static func serialize(data: Gloss.Encodable) throws -> Data {

        guard let prepared = data.toJSON() else {
            throw JSONSerializationErrors.invalidSerialization
        }

        do {
            return try JSONSerialization.data(withJSONObject: prepared, options: [])
        }
        catch {
            throw JSONSerializationErrors.invalidData(error)
        }
    }
    open static func serialize(data: [Gloss.Encodable]) throws -> Data {

        var prepared = [JSON]()
        for entity in data {

            guard let serialized = entity.toJSON() else {
                throw JSONSerializationErrors.invalidSerialization
            }

            prepared.append(serialized)
        }

        do {
            return try JSONSerialization.data(withJSONObject: prepared, options: [])
        }
        catch {
            throw JSONSerializationErrors.invalidData(error)
        }
    }
}
