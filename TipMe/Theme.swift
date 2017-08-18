//
//  Theme.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/18/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import Foundation
import UIKit

enum Theme:Int{
    case light, dark
    
    var mainColor: UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.darkGray
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
}


struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.value(forKey: K.KeyUserDefault.selectedTheme) as? NSNumber {
            return Theme(rawValue: Int(storedTheme))!
        } else {
            return .light
        }
    }
    
    static func storeThemeSelection(_ theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: K.KeyUserDefault.selectedTheme)
        UserDefaults.standard.synchronize()
    }
}
