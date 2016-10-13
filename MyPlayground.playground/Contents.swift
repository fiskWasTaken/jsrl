//: Playground - noun: a place where people can play

import UIKit


let source = "http://jetsetradio.live/chat/messages.xml"

var request = URLRequest(url: URL(string: source)!)
request.httpMethod = "GET"
request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

let task = URLSession.shared.dataTask(with: request as URLRequest) {
    (
    data, response, error) in
    
    guard let data = data, let _:URLResponse = response  , error == nil else {
        print("error")
        return
    }
    
    let dataString =  String(data: data, encoding: String.Encoding.utf8)
    print(dataString)
    
}

task.resume()
