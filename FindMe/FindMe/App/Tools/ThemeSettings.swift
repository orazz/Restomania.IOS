//
//  ThemeSettings.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ThemeSettings {
    
    //MARK: Colors
    public struct Colors {
        
        public static let main = UIColor(red: 246, green: 101, blue: 86)
        public static let divider = UIColor(red: 215, green: 216, blue: 218)
        public static let bullet = UIColor(red: 160, green: 161, blue: 165)

        public static let facebook = UIColor(red: 59, green: 89, blue: 152)
        public static let vk = UIColor(red: 84, green: 118, blue: 155)
        public static let instagram = UIColor(red: 229, green: 47, blue: 140)

        public static let blackText = UIColor(red: 57, green: 51, blue: 53)
        public static let whiteText = UIColor(red: 255, green: 255, blue: 255)
        
        public static let background = UIColor(red: 255, green: 255, blue: 255)
    }

    //MARK: Images
    public struct Images {
        
        public static let `default` = UIImage(named: "default-image", in: Bundle.main, compatibleWith: nil)!
        public static let vkLogo = UIImage(named: "vk", in: Bundle.main, compatibleWith: nil)

        public static let heartActive = UIImage(named: "heart", in: Bundle.main, compatibleWith: nil)
        public static let heartInactive = UIImage(named: "heart-grey", in: Bundle.main, compatibleWith: nil)
    }

    //MARK: Fonts
    public class Fonts {
        
        public static let defaultName = "HelveticaNeue"
        
        public enum Sizes: Int {
            
            case title = 24
            case headline = 18
            case subhead = 14
            case caption = 12
            case substring = 10
        }
        
        
        
        public class func `default`(size: Sizes) -> UIFont {
            
            return UIFont(name: defaultName, size: CGFloat(size.rawValue))!
        }
    }
    
    //MARk: Date & Time formats
    public struct DataTimeFormat {
        
        public static let dateWithTime = "HH:mm dd/MM/yyyy"
        public static let shortTime = "HH:MM"
        public static let shortDate = "dd/MM"
    }

    public static func initializeStyles() {

        //Labels

        //Segment control
        let segment = UISegmentedControl.appearance()
        segment.tintColor = Colors.main
    }
}
