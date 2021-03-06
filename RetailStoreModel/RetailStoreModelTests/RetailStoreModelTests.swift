//
//  RetailStoreModelTests.swift
//  RetailStoreModelTests
//
//  Created by Alfred Reynold on 4/14/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import XCTest
@testable import RetailStoreModel

class RetailStoreModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let modelBundle = Bundle(identifier: "com.alfred.RetailStoreModel")
        if let path = modelBundle?.path(forResource: "items", ofType: "json") {
            do {
                let jsonString = try String.init(contentsOfFile: path, encoding: .utf8)
                XCTAssertNotNil(jsonString, "json string loaded")
            } catch {
                print("Error while reading json file")
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(DataManager.sharedManager.container, "Model succesfully created")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
