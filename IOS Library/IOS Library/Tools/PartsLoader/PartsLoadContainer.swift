
//
//  PartsLoadContainer.swift
//  IOSLibrary
//
//  Created by Алексей on 20.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class PartsLoadContainer: LoadContainerHandler {

    private let target: Any
    private let getter: ((Any) -> Any?)?

    public init(_ target: Any, getter: ((Any) -> Any?)? = nil) {

        self.target = target
        self.getter = getter
    }

    //MARK: LoadContainerHandler
    public fileprivate(set) var isLoad: Bool = false
    public fileprivate(set) var isSuccessLastUpdate: Bool = false

    public var hasData: Bool {
        return nil != getter?(target)
    }
    public var isFail: Bool {
        return isLoad && nil == getter?(target)
    }

    public func startRequest() {
        self.isLoad = false
    }
    public func completeLoad() {
        self.isLoad = true
    }
}
public class PartsLoadTypedContainer<TData> : LoadContainerHandler {

    public private(set) var data: TData?
    public var updateHandler: Action<TData>?
    public var completeLoadHandler: Trigger?

    public init(updateHandler: Action<TData>? = nil, completeLoadHandler: Trigger? = nil) {

        data = nil
        self.updateHandler = updateHandler
        self.completeLoadHandler = completeLoadHandler
    }

    public func update(_ data: TData?) {
        self.data = data

        if let data = data {
            updateHandler?(data)
        }
    }
    public func completeLoad(_ response: ApiResponse<TData>) {
        self.completeLoad()

        if response.isSuccess {
            self.update(response.data)
        }

        self.isSuccessLastUpdate = response.isSuccess
    }

    //MARK: LoadContainerHandler
    public private(set) var isLoad: Bool = false
    public private(set) var isSuccessLastUpdate: Bool = true

    public var isFail: Bool {
        return isLoad && !hasData
    }
    public var hasData: Bool {
        return nil != data
    }

    public func startRequest() {
        self.isLoad = false
    }
    public func completeLoad() {
        self.isLoad = true

        completeLoadHandler?()
    }
}
