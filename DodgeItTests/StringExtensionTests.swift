//
//  StringExtensionTests.swift
//  DodgeItTests
//
//  Created by Jonathan Oh on 10/18/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import XCTest

class StringExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTupleValue() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let testSuccessCases: [Bool] = [
            "0,10".tupleValue()! == (0, 10),
            "1,  1".tupleValue()! == (1, 1),
            " 5 , 5 ".tupleValue()! == (5, 5),
            "123123, 500000".tupleValue()! == (123123, 500000),
            "9 ,0".tupleValue()! == (9, 0)
        ]
        let testFailCases: [Bool] = [
            "0".tupleValue() == nil,
            "".tupleValue() == nil,
            " ".tupleValue() == nil,
            "hi".tupleValue() == nil,
            "-1, -40".tupleValue() == nil,
            "123, -123".tupleValue() == nil,
            "-1, 1".tupleValue() == nil
        ]
        _ = testSuccessCases.map { XCTAssert($0) }
        _ = testFailCases.map { XCTAssert($0) }
    }
}
