//
//  HttpHandler.swift
//  ContactCompanyPOC
//
//  Created by Kapil Rathan on 6/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation

class HttpHandler{
    static fileprivate let queue = DispatchQueue(label: "requests.queue", qos: .utility)
    static fileprivate let mainQueue = DispatchQueue.main
    
    fileprivate class func make(session: URLSession = URLSession.shared, request: URLRequest, closure: @escaping (_ data: Data?, _ error: Error?)->()) {
        
        let task = session.dataTask(with: request) { data, response, error in
            queue.async {
                guard error == nil, let data = data else {
                    closure(nil, error)
                    return
                }
                mainQueue.async {
                    closure(data, nil)
                }
            }
        }
        
        task.resume()
    }
    
    class func fetchCompanyData(urlString: String, closure: @escaping (_ data: Data?, _ error: Error?)->()) {
        guard let url = URL(string: urlString) else {
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

