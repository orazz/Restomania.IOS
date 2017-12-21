//
//  PartsLoadContainer.swift
//  IOSLibrary
//
//  Created by Алексей on 20.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class PartsLoadContainer {

    fileprivate(set) var isLoad: Bool = false
    fileprivate(set) var isSuccessLastUpdate: Bool = false

    public var hasData: Bool {
        return nil != getter?(target)
    }
    public var isFail: Bool {
        return isLoad && nil == getter?(target) 
    }

    private let target: Any
    private let getter: ((Any) -> Any?)?

    public init(_ target: Any, getter: ((Any) -> Any?)? = nil) {

        self.target = target
        self.getter = getter
    }

    public func completeLoad() { }

}
public class PartsLoadTypedContainer<TData> : PartsLoadContainer {

    private(set) public var data: TData?

    public init(_ target: Any) {
        super.init(target)

        data = nil
    }

    //MARK: Properties
    public override var isFail: Bool {
        return isLoad && !hasData
    }
    public override var hasData: Bool {
        return nil != data
    }
    public var updateHandler: Action<TData>?

    //MARK: Methods
    public func update(_ data: TData?) {
        self.data = data

        if let data = data,
            let handler = updateHandler {
            handler(data)
        }
    }
    public func startRequest() {
        self.isLoad = false
    }
    public func completeLoad(_ response: ApiResponse<TData>) {

        self.isLoad = true
        if response.isSuccess {
            self.update(response.data)
        }

        self.isSuccessLastUpdate = response.isSuccess
    }
}
