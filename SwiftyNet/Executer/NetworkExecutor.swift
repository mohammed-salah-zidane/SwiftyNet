//
//  NetworkExecutor.swift
//  SwiftyNet
//
//  Created by prog_zidane on 4/29/21.
//

import Foundation
import Alamofire

public protocol Excutable: class {
    typealias OnProgressCallback = (CFloat) -> ()
    
    func request<T: Codable>(targetRequest: NetworkRequest,
                             responseObject: T.Type,
                             complation: @escaping (NetworkResponse<T>)->())
    
    func requestMultipart<T>(targetRequest: NetworkRequest,
                             responseObject: T.Type,
                             complation: @escaping (NetworkResponse<T>)->(),
                             onProgress: OnProgressCallback?)
}

/// Used to connect to any JSON API that is modeled by an AlamofireEndpoint
public final class NetworkRouter: Excutable {
    
    private var queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    
    public init() {
    
    }
    
    public func request<T: Codable> (
        targetRequest: NetworkRequest,
        responseObject: T.Type,
        complation _complation: @escaping (NetworkResponse<T>)->()
    ) {
        
        let complation: (NetworkResponse<T>)->() = { responce in
            DispatchQueue.main.async { _complation(responce) }
        }

        ApiSessionManager
            .sessionManager
            .request(targetRequest)
            .validate()
            .responseJSON
            { (responce) in
                complation(NetworkResponse(responce))
            }
    }
    
    
    public func requestMultipart<T: Codable> (
        targetRequest: NetworkRequest,
        responseObject: T.Type,
        complation _complation: @escaping (NetworkResponse<T>)->(),
        onProgress _onProgress: OnProgressCallback? = nil
    ) {
        
        let onProgress: OnProgressCallback = { value in
            DispatchQueue.main.async { _onProgress?(value) }
        }
        
        let complation: (NetworkResponse<T>)->() = { responce in
            DispatchQueue.main.async { _complation(responce) }
        }
        
        queue.async {
            ApiSessionManager
                .sessionManager
                .upload(multipartFormData: { (multipartFormData) in
                    if let parameters = targetRequest.parameters {
                        for (key, value) in parameters{
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)")
                        }
                    }
                    targetRequest.multiPart?.forEach({ (multipart) in
                        multipartFormData.append(multipart.fileData, withName: multipart.fileName, fileName: multipart.fileData.format.fileName, mimeType: multipart.fileData.format.mimeType)
                    })
                },with: targetRequest).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        complation(NetworkResponse(response))
                    case .failure(let error):
                        complation(.failure(NetworkError(error)))
                    }
                }).uploadProgress(closure: { (progress) in
                    onProgress(Float(progress.fractionCompleted))
                })
        }
        
    }
    
}
