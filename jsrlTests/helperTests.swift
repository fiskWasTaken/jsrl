//
//  trackListTests.swift
//  jsrl
//
//  Created by Fisk on 12/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import XCTest

@testable import jsrl

class helperTests: XCTestCase {
    let context: Context = Context()
    
    /**
     Ensure that strings are extracted from a JSRl track list appropriately
     */
    func testFilesListArrayParse() {
        let body = "filesListArray[filesListArray.length] = \"2 Mello - My Rhymes Are Nice\";\n" +
            "filesListArray[filesListArray.length] = \"2 Mello - Training Room\";\n" +
            "filesListArray[filesListArray.length] = \"2 Mello - Use Your Mind\";\n" +
        "filesListArray[filesListArray.length] = \"2Pac Dr Dre & Roger Troutman - California Love (Remix by FSG)\";"
        
        let result = context.getTrackLists().parse(body)
        
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], "2 Mello - My Rhymes Are Nice")
        XCTAssertEqual(result[1], "2 Mello - Training Room")
        XCTAssertEqual(result[2], "2 Mello - Use Your Mind")
        XCTAssertEqual(result[3], "2Pac Dr Dre & Roger Troutman - California Love (Remix by FSG)")
    }
    
    /**
 	 Ensure that track URLs are encoded correctly
     */
    func testTrackURLResolve() {
        let source = "2 Mello - My Rhymes Are Nice"
        let expected = "https://jetsetradio.live/audioplayer/audio/2%20Mello%20-%20My%20Rhymes%20Are%20Nice.mp3"
        
        XCTAssertEqual(context.getTracks().resolveUrl(source).absoluteString, expected)
    }
}
