//
//  Theme.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/18/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Theme
enum Theme:Int{
    case light, dark
    
    // Color Scheme Main Background objects
    var mainColor: UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.darkGray
        }
    }
    
    // Color Scheme Text and border elements
    var textColor: UIColor {
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
}

// MARK: - ThemeManager
struct ThemeManager {
    
    // Return Current Theme from User Defaults
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.value(forKey: K.KeyUserDefault.selectedTheme) as? NSNumber {
            return Theme(rawValue: Int(storedTheme))!
        } else {
            return .light
        }
    }
    
    // Store User Selection in User Defaults
    static func storeThemeSelection(_ theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: K.KeyUserDefault.selectedTheme)
        UserDefaults.standard.synchronize()
    }
}
