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
    let context = JSRL()
    
    /**
     Test chat XML decoding
    */
    func testChatXMLDecode() {
        let xml = "<data>" +
            "<message>" +
            "<username><font style='color:#509d97;'>Xelon</font></username>" +
            "<text>" +
            "it's been up for. i dunno. like, a year and a bit now?" +
            "</text>" +
            "<ip>819a37c4546a69431fa311aa6accb0d25d56d158</ip>" +
            "</message>" +
            "<message>" +
            "<username>Beefcake</username>" +
            "<text>neato</text>" +
            "<ip>c8478cc9eecd9f515ea11e6e8664800aaef34d2b</ip>" +
            "</message>" +
            "<message>" +
            "<username>Beefcake</username>" +
            "<text>so how is everyone doing</text>" +
            "<ip>c8478cc9eecd9f515ea11e6e8664800aaef34d2b</ip>" +
        "</message>"
        
        let parser = XMLParser(data: xml.data(using: String.Encoding.utf8)!)
        
        let chatParser = ChatParser()
        parser.delegate = chatParser
        parser.parse()
        
        XCTAssertEqual(3, chatParser.messages.count)
        XCTAssertEqual("819a37c4546a69431fa311aa6accb0d25d56d158", chatParser.messages[0].ip)
        XCTAssertEqual("Beefcake", chatParser.messages[1].username)
        XCTAssertEqual("so how is everyone doing", chatParser.messages[2].text)
    }
    
    
    /**
     Ensure that strings are extracted from a JSRl track list appropriately
     */
    func testFilesListArrayParse() {
        let body = "filesListArray[filesListArray.length] = \"2 Mello - My Rhymes Are Nice\";\r\n" +
            "filesListArray[filesListArray.length] = \"2 Mello - Training Room\";\r\n" +
            "filesListArray[filesListArray.length] = \"2 Mello - Use Your Mind\";\r\n" +
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
        
        XCTAssertEqual(context.getMedia().resolveUrl(source).absoluteString, expected)
    }
    
    func testRequestMessage() {
        let message = RequestMessage(message: "REQUEST: Message text", avatar: "aaaa")
        
        XCTAssertEqual(message.getType(), "REQUEST")
        XCTAssertEqual(message.getText(), "Message text")
    
    }
}
