////
////  WrappedImage.swift
////  FindMe
////
////  Created by Алексей on 25.09.17.
////  Copyright © 2017 Medved-Studio. All rights reserved.
////
//
//import UIKit
//import AsyncTask
//import IOSLibrary
//
//public class WrappedImage: BaseImageWrapper {
//    
//    private let _tag = "WrappedImage"
//    private let _images = ServicesManager.current.images
//    private let _theme = AppSummary.current.theme
//    private var _url: String?
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        initialize()
//    }
//    public required init(coder: NSCoder) {
//        super.init(coder: coder)!
//        
//        initialize()
//    }
//    private func initialize() {
//        
//        self.image = _theme.defaultImage
//        
//        self.contentMode = .scaleAspectFill
//        self.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0)
//        
//    }
//    
//    public func setup(url: String) {
//        
//        let url = prepare(url: url)
//        if (_url == url) {
//            return
//        }
//        
//        _url = url
//        
//        if (String.IsNullOrEmpty(url)) {
//            
//            self.animatedSetupImage(nil)
//            return
//        }
//        
//        let task = _images.download(url: url)
//        task.async(.background, completion: { result in
//            
//            var image: UIImage? = nil
//            
//            if (result.success) {
//                if let data = result.data {
//                    
//                    image = UIImage(data: data)
//                }
//            }
//            
//            self.animatedSetupImage(image)
//        })
//    }
//    private func prepare(url: String) -> String {
//        
//        if (!url.contains("cdn.zerocdn.com")) {
//            
//            return url
//        }
//        
//        let suffix = buildSuffix(size: self.bounds.width)
//        
//        if let suffix = suffix {
//            
//            let lastDotRange = url.range(of: ".", options: .backwards, range: nil, locale: nil)
//            return url.replacingCharacters(in: lastDotRange!, with: "_\(suffix).")
//        } else {
//            
//            return url
//        }
//    }
//    private func buildSuffix(size: CGFloat) -> String? {
//        
//        if (size <= ImageSize.ExtraExtraSmall.rawValue) {
//            
//            return "xss"
//        } else if (size <= ImageSize.ExtraSmall.rawValue) {
//            
//            return "xs"
//        } else if (size <= ImageSize.Small.rawValue) {
//            
//            return "s"
//        } else if (size <= ImageSize.Middle.rawValue) {
//            
//            return "m"
//        } else if (size <= ImageSize.Large.rawValue) {
//            
//            return "l"
//        } else if (size <= ImageSize.ExtraLarge.rawValue) {
//            
//            return "xl"
//        } else {
//            
//            return nil
//        }
//    }
//}

