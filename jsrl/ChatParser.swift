//
//  ChatParser.swift
//  jsrl
//
//  Created by Fisk on 30/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation


class ChatParser : NSObject, XMLParserDelegate  {
    var messages: [ChatMessage] = []
    private var eName: String = String()
    private var map: [String:String] = [:]
    
    private var username = ""
    private var text = ""
    private var ip = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        if elementName == "message" {
            username = ""
            text = ""
            ip = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "message" {
            let message = ChatMessage()
            message.username = username
            message.text = text
            message.ip = ip
            messages.append(message)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            switch (eName) {
            case "username":
                username += data
            case "text":
                text += data
            case "ip":
                ip += data
            default: break
            }
        }
    }
}
