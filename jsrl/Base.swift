//
//  Base.swift
//  jsrl
//
//  Created by Fisk on 30/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation


/**
 XML parsing delegate base
 */
class XMLParserBase: NSObject, XMLParserDelegate {
    var characters: String = ""
    weak var parent:XMLParserBase? = nil
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    
    func parser(_: XMLParser, foundCharacters: String) {
        self.characters += foundCharacters
    }
}
