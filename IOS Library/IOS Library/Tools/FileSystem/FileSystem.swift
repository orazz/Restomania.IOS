//
//  FileSystem.swift
//  IOS Library
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class FileSystem {
    private let _tag = "FileSystem"
    private let _client: FileManager

    public init() {
        _client = FileManager.default
    }

    public func loadBundleFile(_ filename: String) -> String? {
        if let path = Bundle.main.path(forResource: filename, ofType: nil) {
            do {
                return try String(contentsOf: URL(string: path)!)
            } catch {
                return nil
            }
        }

        Log.Warning(_tag, "Can't load file \(filename).")

        return nil
    }
    public func loadBundlePlist(_ filename: String) -> OptionalValue<NSDictionary> {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            return OptionalValue(NSDictionary(contentsOfFile: path))
        }

        Log.Warning(_tag, "Can't load plist file \(filename).")

        return OptionalValue(nil)
    }

    public func isExist(_ filename: String, inCache: Bool ) -> Bool {
        let root = getRoot(inCache: inCache)

        let dirs = _client.urls(for: root, in: .userDomainMask)
        if let dir = dirs.first {
            let url = dir.appendingPathComponent(filename)

            if (url.isFileURL) {
                return _client.fileExists(atPath: url.path)
            } else {
                var isDir: ObjCBool = false
                _client.fileExists(atPath: url.path, isDirectory: &isDir)

                return isDir.boolValue
            }
        }

        return false
    }
    public func createDirectory(_ dirname: String, inCache: Bool ) {
        let root = getRoot(inCache: inCache)

        let dirs = _client.urls(for: root, in: .userDomainMask)
        if let dir = dirs.first {
            let url = dir.appendingPathComponent(dirname)

            do {
                try _client.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                Log.Error(_tag, "Problem with create directory \(url).")
                Log.Error(_tag, String(describing: error))
            }
        } else {
            Log.Warning(_tag, "Not found directory (\(root)).")
        }
    }
    public func load(_ filename: String, fromCache: Bool ) -> String? {
        let root = getRoot(inCache: fromCache)

        let dirs = _client.urls(for: root, in: .userDomainMask)
        if let dir = dirs.first {
            let url = dir.appendingPathComponent(filename)

            if (!_client.isReadableFile(atPath: url.path)) {
                Log.Warning(_tag, "File is not readable (\(url)).")
                return nil
            }

            do {
                return try String(contentsOf: url, encoding: String.Encoding.utf8)
            } catch {
                Log.Error(_tag, "Problem with read data from \(url).")
                Log.Error(_tag, String(describing: error))
            }
        } else {
            Log.Warning(_tag, "Not found directory (\(root)).")
        }

        return nil
    }
    public func saveTo(_ filename: String, data: Data, toCache: Bool ) {
        return saveTo(filename, data: String(data: data, encoding: .utf8)!, toCache: toCache)
    }
    public func saveTo(_ filename: String, data: String, toCache: Bool ) {
        let root = getRoot(inCache: toCache)

        let dirs = _client.urls(for: root, in: .userDomainMask)
        if let dir = dirs.first {
            let url = dir.appendingPathComponent(filename)

            if (isExist(filename, inCache: toCache) && !_client.isWritableFile(atPath: url.path)) {
                Log.Warning(_tag, "File is not writable (\(url)).")
                return
            }

            do {
                try data.write(to: url, atomically: false, encoding: .utf8)
            } catch {
                Log.Error(_tag, "Problem with write data to \(url).")
                Log.Error(_tag, String(describing: error))
            }
        } else {
            Log.Warning(_tag, "Not found directory (\(root)).")
        }
    }
    public func remove(_ filename: String, fromCache: Bool ) {
        let root = getRoot(inCache: fromCache)

        let dirs = _client.urls(for: root, in: .userDomainMask)
        if let dir = dirs.first {
            let url = dir.appendingPathComponent(filename)

            if ( _client.fileExists(atPath: url.path)) {
                do {
                    try _client.removeItem(at: url)
                } catch {
                    Log.Warning(_tag, "Problem with remove file (\(url)).")
                }

            }
        } else {
            Log.Warning(_tag, "Not found directory (\(root)).")
        }
    }
    private func getRoot(inCache: Bool) -> FileManager.SearchPathDirectory {
        var result = FileManager.SearchPathDirectory.documentDirectory
        if (inCache) {
            result = FileManager.SearchPathDirectory.cachesDirectory
        }

        return result
    }
}
