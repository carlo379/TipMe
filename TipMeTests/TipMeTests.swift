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
        let MAX_VAL = Float(20)
        let DEFAULT = Float(15)
        
        tipCalc = TipCalc(withMinTip: MIN_VAL, maxTip: MAX_VAL, defaultTip: DEFAULT)
        XCTAssertNotNil(tipCalc, "Found nil after initialization.")
        XCTAssert(tipCalc!.minTip == MIN_VAL, "Incorrect Initialization of minimum tip value.")
        XCTAssert(tipCalc!.maxTip == MAX_VAL, "Incorrect Initialization of maximum tip value.")
        XCTAssert(tipCalc!.defaultTip == DEFAULT, "Incorrect Initialization of default tip value.")
        guard let tipCalc = tipCalc else { return }

        tipCalc.bill = 100.00
        tipCalc.percentage = 10.00
    }
    
    override func tearDown(){
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTip() {
        guard let tipCalc = tipCalc else { return }

        let tip = tipCalc.getTip()
        XCTAssert(tip == Float(10), "Incorrect Tip Calculation")
    }
    
    func testTotalBill() {
        guard let tipCalc = tipCalc else { return }

        if let totalBill = tipCalc.getTotalBill(){
            XCTAssert(totalBill == Float(110), "Incorrect Total Bill Calculation")
        } else {
            XCTAssertNotNil(tipCalc.getTotalBill()!, "Bill Calculation was nil")
        }
    }
}
