//
//  HTTPRequestApi.swift
//
//  Created by Gerardo on 6/7/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

enum RequestType : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

typealias OnRequestCompletion = (HTTPURLResponse?, String?, Error?) -> Void

class HTTPRequestApi: NSObject {
    
    fileprivate static let TIME_OUT: TimeInterval = 60
    
    class func executeRequest(url: String, requestType: RequestType, headers: [String: String]?, body: String?, timeout: TimeInterval = TIME_OUT, onCompletion: OnRequestCompletion? = nil) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = timeout
        request.httpMethod = requestType.rawValue
        request.allHTTPHeaderFields = headers
        
        if (body != nil) {
            request.httpBody = body!.data(using: String.Encoding.utf8)
        }
            
        let session = URLSession.shared
            
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                let httpResponse = response as? HTTPURLResponse
                let responseString = data != nil ? String(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!) : nil
                
                onCompletion?(httpResponse, responseString, error)
            }
        }).resume()
    }
}
