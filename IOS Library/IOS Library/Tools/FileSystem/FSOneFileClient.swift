//
//  FSOneFileClient.swift
//  IOSLibrary
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class FSOneFileClient {

    private let _tag: String
    public let filename: String
    public let useCache: Bool
    public let fileSystem: FileSystem
    public let blockQueue: DispatchQueue

    public init(filename: String, inCache: Bool, tag: String){

        self.filename = filename
        self.useCache = inCache
        self._tag = tag
        self.fileSystem = FileSystem(tag: "\(tag):\(String.tag(FileSystem.self))")
        self.blockQueue = DispatchQueue(label: "\(tag)-\(Guid.new)")
    }

    //MARK: Methods
    public var isExist: Bool {
        return fileSystem.isExist(filename, inCache: useCache)
    }

    public func loadData() -> Data? {

        var result: Data?
        blockQueue.sync {

            result = self.fileSystem.loadData(self.filename, fromCache: self.useCache)
        }

        return result
    }
    public func load() -> String? {

        var result: String?
        blockQueue.sync {

            result = self.fileSystem.load(self.filename, fromCache: self.useCache)
        }

        return result
    }

    public func save(data: Data) {

        blockQueue.async {

            self.fileSystem.saveTo(self.filename, data: data, toCache: self.useCache)
        }
    }
    public func save(data: String) {

        blockQueue.async {

            self.fileSystem.saveTo(self.filename, data: data, toCache: self.useCache)
        }
    }

    public func remove() {

        blockQueue.async {

            self.fileSystem.remove(self.filename, fromCache: self.useCache)
        }
    }
}
