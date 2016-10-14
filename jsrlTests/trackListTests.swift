//
//  trackListTests.swift
//  jsrl
//
//  Created by Fisk on 12/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import XCTest

@testable import jsrl

class trackListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFilesArrayRemote() {
        let trackLists = Context().getTrackLists()
        
        trackLists.parseUrl(source: "/audioplayer/audio/~list.js", callback: {(strings: [String]) -> () in
            print(strings.count)
        })
    }
    
    func testFilesListArrayParse() {
        let body = "filesListArray[filesListArray.length] = \"2 Mello - My Rhymes Are Nice\";\n" +
            "filesListArray[filesListArray.length] = \"2 Mello - Training Room\";\n" +
            "filesListArray[filesListArray.length] = \"2 Mello - Use Your Mind\";\n" +
        "filesListArray[filesListArray.length] = \"2Pac Dr Dre & Roger Troutman - California Love (Remix by FSG)\";"
        
        let trackLists = Context().getTrackLists()
        
        let result = trackLists.parse(body)
        
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], "2 Mello - My Rhymes Are Nice")
        XCTAssertEqual(result[1], "2 Mello - Training Room")
        XCTAssertEqual(result[2], "2 Mello - Use Your Mind")
        XCTAssertEqual(result[3], "2Pac Dr Dre & Roger Troutman - California Love (Remix by FSG)")
    }
    
    func testTrackURLResolve() {
        let tracks = Context().getTracks()
        let expected = "http://jetsetradio.live/audioplayer/audio/2 Mello - My Rhymes Are Nice.mp3"
        
        XCTAssertEqual(tracks.resolveUrl("2 Mello - My Rhymes Are Nice"), expected)
    }
}
