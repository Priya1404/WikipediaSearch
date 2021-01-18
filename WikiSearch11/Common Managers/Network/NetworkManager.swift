//
//  NetworkManager.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    private let session = URLSession.shared
    
    /// Request with URl & get data
    public func request<Model: Codable>(url: String, success: @escaping (Model) -> Void, failure: @escaping (Error) -> Void) {
        if let apiURL =  URL(string: url) {
            var request = URLRequest(url: apiURL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                DispatchQueue.main.async {
                    do {
                        if let error = error {
                            failure(error)
                        }
                        else {
                            if let data = data {
                                let json1 = try JSONSerialization.jsonObject(with: data, options: [])
                                debugPrint(json1)
                                let json = try JSONDecoder().decode(Model.self, from: data)
                                success(json)
                            }
                        }
                    } catch let error {
                        failure(error)
                    }
                }
            })
            task.resume()
        }
    }
    
    /// Cancel the previous request
    func cancelPreviousRequest() {
        session.getAllTasks { (task) in
            task.forEach { $0.cancel() }
        }
    }
}
