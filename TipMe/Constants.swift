//
//  Constants.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/16/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Data Structures
enum TipRange:Int {
    case min
    case def
    case max
    case rand
}

// MARK: - Constants (K)
struct K {
    struct TipDefault {
        static let min = Float(10)
        static let def = Float(15)
        static let max = Float(20)
    }
    
    struct KeyUserDefault {
        static let min = "TIP_MIN"
        static let def = "TIP_DEFAULT"
        static let max = "TIP_MAX"
        static let bill = "LAST_BILL"
        static let dateInactive = "DATE_BECAME_INACTIVE"
        static let selectedTheme = "SELECTED_THEME"
    }
    
    struct Segue {
        static let tipToSettings = "TipToSettingsSegue"
    }
    
    struct StringFormat {
        static let currency = "$%.2f"
        static let tipLabels = "%.0f"
    }
    
    struct Time {
        static let rememberBill = 10
    }
    
    struct Currency {
        static let error = "-.--"
    }
    
    struct Percentage {
        static let unknown = "???"
    }
    
    struct FontSize {
        static let regular = CGFloat(12)
        static let big = CGFloat(16)
    }
    
    struct AnimationTime {
        static let iconSelect = 0.5
        static let iconStepsDuration = 0.5/3
        static let iconStep1Start = 0.0
        static let iconStep2Start = 0.5/3
        static let iconStep3Start = 1.0/3
    }
}
