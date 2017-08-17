//
//  Float_Ext.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/16/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import Foundation

extension Float {
    var asLocalizedCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber) ?? K.Currency.error
    }
}
