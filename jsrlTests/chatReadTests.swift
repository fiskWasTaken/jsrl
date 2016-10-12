//
//  chatReadTests.swift
//  jsrl
//
//  Created by Fisk on 12/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation


import XCTest
@testable import jsrl

class chatReadTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChat() {
        print("Hello")
        let chat = Context().getChat()
//        chat.fetch(()->())
        print("Goodbye")
    }
}
