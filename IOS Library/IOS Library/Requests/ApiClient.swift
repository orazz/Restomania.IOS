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
    public func GetRange<T: JSONDecodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<[T]> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: InitRange(type:type))
    }
    public func PostRange<T: JSONDecodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<[T]> {
        return SendTo(action, method: .Post, parameters: Wrap(parameters), parser: InitRange(type:type))
    }
    public func PutRange<T: JSONDecodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<[T]> {
        return SendTo(action, method: .Put, parameters: Wrap(parameters), parser: InitRange(type:type))
    }
    public func DeleteRange<T: JSONDecodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<[T]> {
        return SendTo(action, method: .Delete, parameters: Wrap(parameters), parser: InitRange(type:type))
    }
    private func InitRange<T: JSONDecodable>(type: T.Type) -> (_:Any?) -> [T] {
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
    public func GetLong(action: String, parameters: Parameters? = nil) -> RequestResult<Long> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: InitLong())
    }
    public func GetLongRange(action: String, parameters: Parameters? = nil) -> RequestResult<[Long]> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: { $0 as! [Long] })
    }
    public func PostLong(action: String, parameters: Parameters? = nil) -> RequestResult<Long> {
        return SendTo(action, method: .Post, parameters: Wrap(parameters), parser: InitLong())
    }
    public func PutLong(action: String, parameters: Parameters? = nil) -> RequestResult<Long> {
        return SendTo(action, method: .Put, parameters: Wrap(parameters), parser: InitLong())
    }
    public func DeleteLong(action: String, parameters: Parameters? = nil) -> RequestResult<Long> {
        return SendTo(action, method: .Delete, parameters: Wrap(parameters), parser: InitLong())
    }
    private func InitLong() -> (_:Any?) -> Long {
        return { json in json as! Long }
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
    public func Get<T: JSONDecodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return SendTo(action, method: .Get, parameters: Wrap(parameters), parser: InitT())
    }
    public func Post<T: JSONDecodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return SendTo(action, method: .Post, parameters: Wrap(parameters), parser: InitT())
    }
    public func Put<T: JSONDecodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return SendTo(action, method: .Put, parameters: Wrap(parameters), parser: InitT())
    }
    public func Delete<T: JSONDecodable>(action: String, type: T.Type, parameters: Parameters? = nil) -> RequestResult<T> {
        return SendTo(action, method: .Delete, parameters: Wrap(parameters), parser: InitT())
    }
    private func InitT<T: JSONDecodable>() -> (_:Any?) -> T {
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

            Log.Debug(self._tag, "Request to \(url)")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    Log.error(self._tag, "Fundamental problem with request.")
                    Log.error(self._tag, "Error: \(error)")

                    handler(ApiResponse(statusCode: .ConnectionError, response: response))
                    return
                }

                if let httpStatus = response as? HTTPURLResponse,
                    httpStatus.statusCode != 200 {

                    Log.warning(self._tag, "Response status code is \(httpStatus.statusCode)")
                    Log.error(self._tag, "Response status code is not success.")

                    handler(ApiResponse(statusCode: .InternalServerError, response: response))
                    return
                }

                Log.Debug(self._tag, "Response from \(url)")
                do {
                    let content = String(data: data!, encoding: .utf8)!
                    let json =  try JSONSerialization.jsonObject(with: data!, options: []) as! JSON

                    let apiResponse = ApiResponse<TData>(json: json, response: response, content: content)
                    if (apiResponse.statusCode == .OK) {
                        apiResponse.data = parser(json["Data"])
                    }

                    handler(apiResponse)

                } catch {
                    Log.error(self._tag, "Problem with parse response from \(url).")

                    handler(ApiResponse(statusCode: .InternalServerError, response: response))
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
            Log.error(_tag, "Problem with serialize parameters for request.")

        }
        let body = "parameters=\(parametersContent.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"

        return body.data(using: .utf8)!
    }
}
