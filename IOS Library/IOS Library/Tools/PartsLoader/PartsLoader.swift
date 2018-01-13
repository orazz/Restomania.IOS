//
//  PartsLoader.swift
//  IOSLibrary
//
//  Created by Алексей on 20.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public protocol LoadContainerHandler {

    var isLoad: Bool { get }

    var hasData: Bool { get }
    var problemWithLoad: Bool { get }

    func startRequest()
    func completeLoad()
}
public class PartsLoader: LoadContainerHandler {

    private var loaders: [LoadContainerHandler]

    public init(_ loaders: [LoadContainerHandler]) {

        self.loaders = loaders
    }

    //MARK: LoadContainerHandler
    public var isLoad: Bool {
        return loaders.all{ $0.isLoad }
    }

    public var noData: Bool {
        return loaders.any({ !$0.hasData })
    }
    public var hasData: Bool {
        return loaders.all{ $0.hasData }
    }
    public var problemWithLoad: Bool {
        return loaders.any{ $0.problemWithLoad }
    }

    public func startRequest() {
        loaders.each{ $0.startRequest() }
    }
    public func completeLoad() {
        loaders.each{ $0.completeLoad() }
    }
}
