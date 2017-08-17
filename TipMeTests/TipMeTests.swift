//
//  TipMeTests.swift
//  TipMeTests
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import XCTest
@testable import TipMe

class TipMeTests: XCTestCase {
    var tipCalc:TipCalc?
    
    override func setUp() {
        super.setUp()
        
        let MIN_VAL = Float(10)
        let DEFAULT = Float(15)
        let MAX_VAL = Float(20)

        tipCalc = TipCalc(withMinTip: MIN_VAL, maxTip: MAX_VAL, defaultTip: DEFAULT)
        XCTAssertNotNil(tipCalc, "Found nil after initialization.")
        XCTAssert(tipCalc?.tipRangeValues[0] == MIN_VAL,"Tip Range Values not correctly initialized")
        XCTAssert(tipCalc?.tipRangeValues[1] == DEFAULT,"Tip Range Values not correctly initialized")
        XCTAssert(tipCalc?.tipRangeValues[2] == MAX_VAL,"Tip Range Values not correctly initialized")
    }
    
    override func tearDown(){
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        tipCalc = nil
    }
    
    func testTipAndTotalUsingPercentage() {
        guard let tipCalc = tipCalc else { return }
        
        let bill = Float(100)
        let percentage = Float(12)

        let tipAndTotalUsingPercentage = tipCalc.getTipAndTotal(fromBill: bill, andPercentage: percentage)

        XCTAssert(tipAndTotalUsingPercentage.tip == Float(12), "Incorrect Tip Calculation")
        XCTAssert(tipAndTotalUsingPercentage.total == Float(112), "Incorrect Total Bill Calculation")

    }
    
    func testTipAndTotalUsingDecimalPercentage() {
        guard let tipCalc = tipCalc else { return }
        
        let bill = Float(100)
        let decimalPercentage = Float(0.12)
        
        let tipAndTotalUsingDecimalPercentage = tipCalc.getTipAndTotal(fromBill: bill, andPercentage: decimalPercentage)
        
        XCTAssert(tipAndTotalUsingDecimalPercentage.tip == Float(12), "Incorrect Tip Calculation using decimal percentage")
        XCTAssert(tipAndTotalUsingDecimalPercentage.total == Float(112), "Incorrect Total Bill Calculation using decimal percentage")
        
    }
}
