//
//  Constants.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/16/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import Foundation

enum TipRange:Int {
    case min
    case def
    case max
}

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
    }
    
    struct Segue {
        static let tipToSettings = "TipToSettingsSegue"
    }
    
    struct StringFormat {
        static let currency = "$%.2f"
        static let segmentCtrl = "%.0f"
    }
    
    struct Time {
        static let rememberBill = 10
    }
    
    struct Currency {
        static let error = "-.--"
    }
}
