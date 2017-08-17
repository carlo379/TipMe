//
//  calculator.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import Foundation

enum TipRange {
    case min(Float)
    case def(Float)
    case max(Float)
}

class TipCalc {
    
    /// Array of Float values representing the possible tips
    var tipRangeValues = [Float]()
    
    /**
     Initializes a new Tip Calculator with Minimum, Default and Maximum tip values
     
     - Parameters:
     - min: 'Float' value representing the minimum tip on a tip range.
     - def: 'Float' value representing the default tip on a tip range.
     - max: 'Float' value representing the maximum tip on a tip range.
     
     - Returns: New 'TipCalc' instance
     */
    init(withMinTip min:Float, maxTip max:Float, defaultTip def:Float){
        setTipRangeValues(min: min, def: def, max: max)
    }
    
    /**
     Set 'tipRangeValue' property with minimun, default and maximun tip values.
     
     - Parameters:
     - min: 'Float' value representing the minimum tip on a tip range.
     - def: 'Float' value representing the default tip on a tip range.
     - max: 'Float' value representing the maximum tip on a tip range.
     
     - Returns: Void
     */
    func setTipRangeValues(min:Float, def:Float, max:Float){
        tipRangeValues.insert(min, at: 0)
        tipRangeValues.insert(def, at: 1)
        tipRangeValues.insert(max, at: 2)
    }

    /**
     Calculate 'tip' and 'total bill' from provided bill amount and tip percentage.
     
     - Parameters:
     - bill: The style of the bicycle
     - percent: The gearing of the bicycle
     
     - Returns: '(tip:Float, total:Float)' tuple containing the 'tip' and the 'total' of the bill
     */
    func getTipAndTotal(fromBill bill:Float, andPercentage percent:Float)->(tip:Float, total:Float){
        var percentConverted = percent
        if percent >= Float(1){
            percentConverted = percentConverted/Float(100)
        }
        let tip = bill*percentConverted
        let total = bill+tip
        
        return (tip,total)
    }

}
