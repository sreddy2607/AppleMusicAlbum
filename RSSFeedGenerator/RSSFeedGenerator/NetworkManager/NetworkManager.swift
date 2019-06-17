//
//  NetworkManager.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import Foundation

enum httpMethod: String {
    case getMethod = "GET"
    case postMethod = "POST"
    case putMethod = "PUT"
}

protocol RequestObject {
    var url: URL{get}
    var host: String{get}
    var path: String{get}
    var method: String{get}
    var body: [String: Any]? {get}
    var headers: [[String: Any]]? {get}
    
    associatedtype response: ResponseObject
}

protocol ResponseObject {
    static func parse(data: Data, success: Bool) -> Self?
}

class SCError: NSObject {
    var errorDescription: String!
    var errorCode: Int!
    var serverError: Error!
    
    override init() {
        super.init()
    }
    
    convenience init(description: String, responseCode: Int, error: Error?) {
        self.init()
        self.errorDescription = description
        self.errorCode = responseCode
        self.serverError = error
    }
}

extension Error {
    var code: Int {return (self as NSError).code }
}

typealias Completion<T: RequestObject> = (_ success: Bool, _ response: T.response?, _ error: SCError?) -> ()

class NetworkManager {
    
    //MARK:- Singleton Instance
    static let networkManager = NetworkManager()
    
    //MARK:- URL: Request/Responce
    func send<T: RequestObject>(r: T, completion:@escaping Completion<T>) {
        
        let url = r.url
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 40
        urlRequest.httpMethod = r.method
        
        if r.headers != nil {
            for header in r.headers! {
                let key = header.keys.first!
                urlRequest.addValue((header[key] as? String)!, forHTTPHeaderField: key)
            }
        }
        
        if r.body != nil {
            let body = try! JSONSerialization.data(withJSONObject: r.body, options: .init(rawValue: 0))
            let bodyString = String(data: body, encoding: .utf8)
            urlRequest.httpBody = bodyString?.data(using: .utf8)
        }
        
        let urlSessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession.init(configuration: urlSessionConfig, delegate: nil, delegateQueue: .main)
        let urlSessionTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let er = error {
                print("ERROR: \(er)")
            }
            
            guard error == nil else {
                completion(false, nil, SCError(description: (error?.localizedDescription)!, responseCode: (error?.code)!, error: error!))
                return
            }
            
            guard response is HTTPURLResponse else {
                completion(false, nil, SCError())
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode != 404 else {
                completion(false, nil, SCError(description: "Something went wrong, Please try again", responseCode: (response as! HTTPURLResponse).statusCode, error: error))
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode != 400 else {
                completion(false, nil, SCError(description: "Something went wrong, Please try again", responseCode: (response as! HTTPURLResponse).statusCode, error: error))
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode != 401 else {
                completion(false, nil, SCError(description: "Something went wrong, Please try again", responseCode: (response as! HTTPURLResponse).statusCode, error: error))
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode != 502 else {
                completion(false, nil, SCError(description: "Something went wrong, Please try again", responseCode: (response as! HTTPURLResponse).statusCode, error: error))
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode != 500 else {
                completion(false, nil, SCError(description: "Something went wrong, Please try again", responseCode: (response as! HTTPURLResponse).statusCode, error: error))
                return
            }
            
            guard data != nil else {
                completion(false, nil, SCError())
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode == 200 else {
                let res = T.response.parse(data: data!, success: true)
                completion(false, res, SCError())
                return
            }
            
            let res = T.response.parse(data: data!, success: true)
            guard res != nil else {
                completion(false, res, nil)
                return
            }
            completion(true, res, nil)
        }
        
        urlSessionTask.resume()
    }
}
