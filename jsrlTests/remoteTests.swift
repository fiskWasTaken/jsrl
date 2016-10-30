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

/**
 Tests that load from a remote source
 */
class remoteTests: XCTestCase {
    let context = JSRL()
    
    func testChatTail() {
        
    }
    
    func testChat() {
        let exp = expectation(description: "Fetch the chat log")
        
        context.getChat().fetch({_, messages in
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
    func testTrackFetch() {
        let exp = expectation(description: "Fetch an MP3 from JSRl")
        
        context.getTracks().get("2 Mello - My Rhymes Are Nice", { err, data in
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 20, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
    
    func testFilesArrayRemote() {
        let exp = expectation(description: "Fetch the source track list JS from JSRl")
        
        context.getTrackLists().parseUrl(source: "/audioplayer/audio/~list.js", callback: {(err, strings: [String]) -> () in
            print(strings[0])
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        })
    }
}
