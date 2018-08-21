//
//  HttpHandler.swift
//  20180101-KapilRathan-NYCSchools
//
//  Created by Kapil Rathan on 8/21/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation

class HttpHandler{
    static fileprivate let queue = DispatchQueue(label: "requests.queue", qos: .utility)
    static fileprivate let mainQueue = DispatchQueue.main
    
    fileprivate class func make(session: URLSession = URLSession.shared, request: URLRequest, closure: @escaping (_ data: Data?, _ error: Error?)->()) {
        
        let task = session.dataTask(with: request) { data, response, error in
            queue.async {
                if error == nil, let data = data{
                    //Update UI on main thread
                    mainQueue.async {
                        closure(data, nil)
                    }
                }else{
                     closure(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Make API request
    
    class func HttpHandlerMakeRequest(urlString: String, closure: @escaping (_ data: Data?, _ error: Error?)->()) {
        guard let url = URL.init(string: urlString)else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        HttpHandler.make(request: request) { data, error in
            closure(data, error)
        }
        
    }
}

