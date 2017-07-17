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
    private let _client = FileManager.default

    public func LoadBundleFile(_ filename: String) -> String? {
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
    public func LoadBundlePlist(_ filename: String) -> NSDictionary? {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }

        Log.Warning(_tag, "Can't load plist file \(filename).")

        return nil
    }

    public func IsExist(_ filename: String, inCache: Bool ) -> Bool {
        let root = GetRoot(inCache: inCache)

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
    public func CreateDirectory(_ dirname: String, inCache: Bool ) {
        let root = GetRoot(inCache: inCache)

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
    public func Load(_ filename: String, fromCache: Bool ) -> String? {
        let root = GetRoot(inCache: fromCache)

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
    public func SaveTo(_ filename: String, data: String, toCache: Bool ) {
        let root = GetRoot(inCache: toCache)

        let dirs = _client.urls(for: root, in: .userDomainMask)
        if let dir = dirs.first {
            let url = dir.appendingPathComponent(filename)

            if (IsExist(filename, inCache: toCache) && !_client.isWritableFile(atPath: url.path)) {
                Log.Warning(_tag, "File is not writable (\(url)).")
                return
            }

            do {
                try data.write(to: url, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                Log.Error(_tag, "Problem with write data to \(url).")
                Log.Error(_tag, String(describing: error))
            }
        } else {
            Log.Warning(_tag, "Not found directory (\(root)).")
        }
    }
    public func Remove(_ filename: String, fromCache: Bool ) {
        let root = GetRoot(inCache: fromCache)

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
    private func GetRoot(inCache: Bool) -> FileManager.SearchPathDirectory {
        var result = FileManager.SearchPathDirectory.documentDirectory
        if (inCache) {
            result = FileManager.SearchPathDirectory.cachesDirectory
        }

        return result
    }
}
