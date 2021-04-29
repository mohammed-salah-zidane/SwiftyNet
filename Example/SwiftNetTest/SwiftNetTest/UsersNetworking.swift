//
//  UsersNetworking.swift
//  SwiftNetTest
//
//  Created by prog_zidane on 4/29/21.
//

import Foundation
import Alamofire
import SwiftyNet

enum UsersRequests {
    case getUsers
    case createUser(name: String, job: String)
}

extension UsersRequests: NetworkRequest {
    var path: String {
        switch self {
        case .getUsers:
            return "/employees"
        case .createUser:
            return "/users"
        }
    }
    
    var baseUrl: URL {
        switch self {
        case .getUsers:
            return URL(string:"http://dummy.restapiexample.com/api/v1")!
        default:
            return URL(string:"https://reqres.in/api")!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        case .createUser:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getUsers:
            return nil
        case .createUser(let name, let job):
            return ["name": name, "job": job]
        }
    }
    
    var parameterEncoding: RequestParameterEncoding? {
        switch self {
        case .getUsers:
            return .queryString
        case .createUser:
            return .json
        }
    }
    
}
