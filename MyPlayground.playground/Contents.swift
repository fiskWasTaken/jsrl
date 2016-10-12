import UIKit
import Foundation
import PlaygroundSupport

let body = "filesListArray[filesListArray.length] = \"2 Mello - My Rhymes Are Nice\";\n" +
"filesListArray[filesListArray.length] = \"2 Mello - Training Room\";\n" +
"filesListArray[filesListArray.length] = \"2 Mello - Use Your Mind\";\n" +
"filesListArray[filesListArray.length] = \"2Pac Dr Dre & Roger Troutman - California Love (Remix by FSG)\";"

let pattern = ".* = \"(.*)\""

let regex = try! NSRegularExpression(pattern: pattern, options: [])

let matches = regex.matches(in: body, options: [], range: NSRange(location: 0, length: body.characters.count))

for match in matches {
    let range = match.rangeAt(1)
    
    let indexStartOfText = body.index(body.startIndex, offsetBy: range.location)
    let indexEndOfText = body.index(body.startIndex, offsetBy: range.location + range.length)
    let subString3 = body.substring(with: indexStartOfText ..< indexEndOfText)

    
//    print(body.substring(with: range.location ..< (range.location + range.length)))
//    
//    print(match.rangeAt(1).length)
//    for n in 0..<match.numberOfRanges {
//        let range = match.rangeAt(n)
//        let r = body.startIndex.advancedBy(range.location) ..<
//            body.startIndex.advancedBy(range.location+range.length)
//        body.substringWithRange(r)
//    }
}