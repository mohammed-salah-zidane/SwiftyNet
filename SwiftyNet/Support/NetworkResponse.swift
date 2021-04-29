//
//  NetworkResponse.swift
//  SwiftyNet
//
//  Created by prog_zidane on 4/29/21.
//

import Foundation
import Alamofire

/// The response from a method that can result in either a successful or failed state
typealias DataResponseType  = AFDataResponse<Any>

public enum NetworkResponse<T: Codable> {
    case success(data: T)
    case failure(NetworkError)
    
    init(_ dataResponse: DataResponseType) {
        
        guard dataResponse.error == nil else {
            self = .failure(NetworkError(dataResponse.error!))
            print(dataResponse)

            return
        }
        
        guard dataResponse.response != nil else {
            self = .failure(NetworkError(dataResponse.response!.statusCode))
            return
        }
        
        guard dataResponse.response?.hasSuccessStatusCode == true else {
            self = .failure(NetworkError(dataResponse.response!.statusCode))
            return
        }
        
        
        guard let jsonResponse = try? dataResponse.result.get() else {
            self = .failure(NetworkError(dataResponse.response!.statusCode))
            return
        }
        
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
            self = .failure(.parsingJSONError)
            return
        }
        guard let responseObj = try? JSONDecoder().decode(T.self, from: theJSONData) else {
            self = .failure(.parsingJSONError)
            return
        }
        
        self = .success(data: responseObj)
    }
    
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
