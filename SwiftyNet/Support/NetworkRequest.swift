//
//  NetworkRequest.swift
//  SwiftyNet
//
//  Created by prog_zidane on 4/29/21.
//

import Foundation
import Alamofire

// Multipart Model
public struct MultipartData {
    var fileName = "media"
    var fileData : Data = Data()
}

/// A simple protocol to that holds the request related properties
public protocol NetworkRequest: URLRequestConvertible {
    var path:              String                    {get}
    var pathContainsHost:  Bool                      {get}
    var baseUrl:           URL                       {get}
    var method:            HTTPMethod                {get}
    var parameters:        Parameters?               {get}
    var parameterEncoding: RequestParameterEncoding? {get}
    var headers:           [String: Any]?            {get}
    var dataType:          DataType                  {get}
    var multiPart:         [MultipartData]?          {get}
}

extension NetworkRequest {
    
    public var pathContainsHost: Bool {
        return false
    }
    
    public var headers: [String : Any]? {
        var headers = [String : Any]()
        headers["Content-type"] = "application/x-www-form-urlencoded; charset=utf-8"
        headers["Content-type"] = "application/json"
        headers["Accept"] = "application/json"
        return headers
    }
    
    public var dataType: DataType {
        return .JSON
    }
    
    public var multiPart: [MultipartData]? {
        return nil
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try (baseUrl).asURL()
        var urlRequest = URLRequest(url: pathContainsHost ? URL(string: path)! : url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            if let encodingType = parameterEncoding {
                urlRequest = try encodingType.encoding.encode(urlRequest, with: params)
            } else {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            }
        }
        
        if let headers = headers {
            headers.forEach {
                if let value = $0.value as? String {
                    urlRequest.setValue(value, forHTTPHeaderField: $0.key)
                }
            }
        }
        
        urlRequest.timeoutInterval = 120
        return urlRequest
    }
}

public enum RequestParameterEncoding: String {
    // json means you send paramter in => Body "Postman"
    // queryString means you send paramter in => Params "Postman"
    case queryString, httpBody, json
    
    public var encoding: ParameterEncoding {
        switch self {
        case .queryString:
            return URLEncoding.queryString
        case .httpBody:
            return URLEncoding.httpBody
        case .json:
            return JSONEncoding.default
        }
    }
}

public enum DataType {
    case JSON
    case data
}
