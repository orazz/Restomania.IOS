//
//  DataUrl.swift
//  IOSLibrary
//
//  Created by Алексей on 14.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class DataUrl {

    public static func convert(_ image: UIImage) -> String? {

        if let data = UIImageJPEGRepresentation(image, 0.5) {

            var dataUrl = data.base64EncodedString(options: .lineLength76Characters)
                              .replacingOccurrences(of: " ", with: "+")

            while (0 != dataUrl.lengthOfBytes(using: .utf8) % 4) {
                dataUrl.append("=")
            }

//            return dataUrl
            return "data:image/jpeg;base64,\(dataUrl)"
        }

        return nil
    }
    private static func encode(_ dataUrl: String) -> String? {
        let allowedCharacters = URLQueryParameterAllowedCharacterSet()
//        let allowedCharacters = NSCharacterSet.urlFragmentAllowed

        return dataUrl.addingPercentEncoding(withAllowedCharacters: allowedCharacters)?.replacingOccurrences(of: " ", with: "+")
//        return dataUrl
    }
    private static func URLQueryParameterAllowedCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/? ")
    }
}
