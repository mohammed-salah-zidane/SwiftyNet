//
//  UsersRouter.swift
//  SwiftNetTest
//
//  Created by prog_zidane on 4/29/21.
//

import Foundation

import SwiftyNet

class UserModel: Codable {
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "employee_name"
    }
}

class BaseResponse<T: Codable>: Codable {
    var status: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}
