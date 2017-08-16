//
//  calculator.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import Foundation

class TipCalc {
    
    var bill:Float?
    var _percentage:Float?
    var percentage:Float? {
        get {
            return _percentage
        }
        set(newPercentage) {
            if let newPercentage = newPercentage {
                _percentage = newPercentage/Float(100)
            }
        }
    }
    private var tip:Float?
    
    var minTip:Float
    var maxTip:Float
    var defaultTip:Float
    
    init(withMinTip min:Float, maxTip max:Float, defaultTip:Float){
        self.minTip = min
        self.maxTip = max
        self.defaultTip = defaultTip
    }
    
    func getTip()->Float?{
        guard let billAmount = self.bill, let percentageAmount = self.percentage else {return nil}
        return billAmount*percentageAmount
    }
    
    func getTotalBill()->Float?{
        guard let getTip = getTip(), let bill = bill else { return nil }
        return getTip+bill
    }
}
