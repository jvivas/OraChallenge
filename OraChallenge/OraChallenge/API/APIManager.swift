//
//  APIManager.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/5/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum BackendError: Error {
    case objectSerialization(reason: String)
}

class APIManager: NSObject {
    let baseUrl = "https://private-93240c-oracodechallenge.apiary-mock.com/"
    
    func request(path:String, method: HTTPMethod, parameters: Parameters, onSuccess:@escaping ((SwiftyJSON.JSON) -> Void), onFailed:@escaping ((String, Int) -> Void)) {
        Alamofire.request(baseUrl+path, method: method, parameters:parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let authToken = response.response?.allHeaderFields["Authorization"] as? String {
                        DefaultsManager.saveAuthToken(token: authToken)
                    }
                    
                    if let value = response.result.value {
                        let json = SwiftyJSON.JSON(value)
                        onSuccess(json)
                    }
            
                    
                case .failure (let error):
                    // Handle status codes
                    if let statusCode = response.response?.statusCode {
                        self.handleStatusCode(statusCode: statusCode)
                    }
                    
                    var errorMessage = error.localizedDescription
                    if let data = response.data {
                        let responseJSON = JSON(data: data)
                        
                        if let message: String = responseJSON["message"].string {
                            if !message.isEmpty {
                                errorMessage = message
                            }
                        }
                    }
                    onFailed(errorMessage, (response.response?.statusCode)!)
                }
        }
    }
    
    func handleStatusCode(statusCode:Int) {
        if statusCode == 401 { // TODO Unauthorized
        }
    }
}