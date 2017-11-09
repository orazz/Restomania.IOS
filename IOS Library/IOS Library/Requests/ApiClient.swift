//
//  ApiClient.swift
//  IOS Library
//
//  Created by Алексей on 15.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import AsyncTask

public typealias Parameters = [String: Any?]
public typealias RequestResult<T> = Task<ApiResponse<T>>
public class ApiClient {
    private let _url: String
    private let _tag: String

    public init(url: String, tag: String) {
        self._url = url
        self._tag = tag
    }
    //Range decodable
    public func GetRange<T: Gloss.Decodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<[T]> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: InitRange(type:type))
    }
    public func PostRange<T: Gloss.Decodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<[T]> {
        return SendTo(action, method: .Post, parameters: Wrap(parameters), parser: InitRange(type:type))
    }
    public func PutRange<T: Gloss.Decodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<[T]> {
        return SendTo(action, method: .Put, parameters: Wrap(parameters), parser: InitRange(type:type))
    }
    public func DeleteRange<T: Gloss.Decodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<[T]> {
        return SendTo(action, method: .Delete, parameters: Wrap(parameters), parser: InitRange(type:type))
    }
    private func InitRange<T: Gloss.Decodable>(type: T.Type) -> (_:Any?) -> [T] {
        return { json in

            let range = json as! [JSON]

            var result = [T]()
            for element in range {
                if let data = T(json: element) {
                    result.append(data)
                }
            }

            return result
        }
    }
    //String
    public func GetString(action: String, parameters: Parameters? = nil) -> RequestResult<String> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: InitString())
    }
    public func PostString(action: String, parameters: Parameters? = nil) -> RequestResult<String> {
        return SendTo(action, method: .Post, parameters: Wrap(parameters), parser: InitString())
    }
    public func PutString(action: String, parameters: Parameters? = nil) -> RequestResult<String> {
        return SendTo(action, method: .Put, parameters: Wrap(parameters), parser: InitString())
    }
    public func DeleteString(action: String, parameters: Parameters? = nil) -> RequestResult<String> {
        return SendTo(action, method: .Delete, parameters: Wrap(parameters), parser: InitString())
    }
    private func InitString() -> (_:Any?) -> String {
        return { json in json as! String }
    }

    //Long
    public func GetLong(action: String, parameters: Parameters? = nil) -> RequestResult<Int64> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: InitLong())
    }
    public func PostLong(action: String, parameters: Parameters? = nil) -> RequestResult<Int64> {
        return SendTo(action, method: .Post, parameters: Wrap(parameters), parser: InitLong())
    }
    public func PutLong(action: String, parameters: Parameters? = nil) -> RequestResult<Int64> {
        return SendTo(action, method: .Put, parameters: Wrap(parameters), parser: InitLong())
    }
    public func DeleteLong(action: String, parameters: Parameters? = nil) -> RequestResult<Int64> {
        return SendTo(action, method: .Delete, parameters: Wrap(parameters), parser: InitLong())
    }
    private func InitLong() -> (_:Any?) -> Int64 {
        return { json in json as! Int64 }
    }

    //Bool
    public func GetBool(action: String, parameters: Parameters? = nil) -> RequestResult<Bool> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: InitBool())
    }
    public func PostBool(action: String, parameters: Parameters? = nil) -> RequestResult<Bool> {
        return SendTo(action, method: .Post, parameters: Wrap(parameters), parser: InitBool())
    }
    public func PutBool(action: String, parameters: Parameters? = nil) -> RequestResult<Bool> {
        return SendTo(action, method: .Put, parameters: Wrap(parameters), parser: InitBool())
    }
    public func DeleteBool(action: String, parameters: Parameters? = nil) -> RequestResult<Bool> {
        return SendTo(action, method: .Delete, parameters: Wrap(parameters), parser: InitBool())
    }
    private func InitBool() -> (_:Any?) -> Bool {
        return { json in json as! Bool }
    }

    //Decodable
    public func Get<T: Gloss.Decodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: InitT())
    }
    public func Post<T: Gloss.Decodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return SendTo(action, method: .Post, parameters: Wrap(parameters), parser: InitT())
    }
    public func Put<T: Gloss.Decodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return SendTo(action, method: .Put, parameters: Wrap(parameters), parser: InitT())
    }
    public func Delete<T: Gloss.Decodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return SendTo(action, method: .Delete, parameters: Wrap(parameters), parser: InitT())
    }
    private func InitT<T: Gloss.Decodable>() -> (_:Any?) -> T {
        return { json in T(json: json as! JSON)! }
    }

    private func Wrap(_ parameters: Parameters?) -> Parameters {
        if let parameters = parameters {
            return parameters
        } else {
            return Parameters()
        }
    }

    private func SendTo<TData>(_ path: String, method: HttpMethod, parameters: Parameters, parser:@escaping (_:Any?) -> TData) -> RequestResult<TData> {
        let url = Build(url: _url, path: path, method: method)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = Build(parameters: parameters)
        request.allHTTPHeaderFields?["Content-type"] = "application/x-www-form-urlencoded"

        return Task { (handler: @escaping (_:ApiResponse<TData>) -> Void) in

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    Log.Error(self._tag, "Fundamental problem with request.")
                    Log.Error(self._tag, "Error: \(error)")

                    handler(ApiResponse(statusCode: .ConnectionError))
                    return
                }

                if let httpStatus = response as? HTTPURLResponse,
                    httpStatus.statusCode != 200 {

                    Log.Warning(self._tag, "Response status code is \(httpStatus.statusCode)")
                    Log.Error(self._tag, "Response status code is not success.")

                    handler(ApiResponse(statusCode: .InternalServerError))
                    return
                }

                Log.Debug(self._tag, "Response from \(url)")
                do {
                    let stringContent = String(data: data!, encoding: .utf8)!
                    let data =  try JSONSerialization.jsonObject(with: data!, options: [])
                    let json = data as! JSON

                    let apiResponse = ApiResponse<TData>(json: json)
                    if (apiResponse.statusCode == .OK) {
                        apiResponse.data = parser(json["Data"])
                        handler(apiResponse)
                    } else {
                        handler(apiResponse)
                    }

                } catch {
                    Log.Error(self._tag, "Problem with parse response result.")

                    handler(ApiResponse(statusCode: .InternalServerError))
                }
            }
            task.resume()
        }
    }
    private func Build(url: String, path: String, method: HttpMethod) -> URL {
        let builded = "\(url)/\(path)?__type=\(method.rawValue)"

        return URL(string: builded)!
    }
    private func Build(parameters: Parameters) -> Data {

        var builded = JSON()
        for (key, value) in parameters {

            if (nil == value) {
                continue
            }

            builded[key] = value
        }

        var parametersContent = ""
        do {
            let parameters = try JSONSerialization.data(withJSONObject: builded, options: [])
            parametersContent = String(data: parameters, encoding: .utf8)!
        } catch {
            Log.Error(_tag, "Problem with serialize parameters for request.")

        }
        let body = "parameters=\(parametersContent.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"

        return body.data(using: .utf8)!
    }
}
