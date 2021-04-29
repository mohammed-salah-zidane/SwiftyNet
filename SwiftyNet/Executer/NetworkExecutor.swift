//
//  NetworkExecutor.swift
//  SwiftyNet
//
//  Created by prog_zidane on 4/29/21.
//

import Foundation
import Alamofire

protocol Excutable: class {
    typealias OnProgressCallback = (CFloat) -> ()
    
    func request<T: Codable>(request: NetworkRequest,
                             complation: @escaping (NetworkResponse<T>)->())
    
    func requestMultipart<T>(request: NetworkRequest,
                             complation: @escaping (NetworkResponse<T>)->(),
                             onProgress: OnProgressCallback?)
}

/// Used to connect to any JSON API that is modeled by an AlamofireEndpoint
final class NetworkRouter: Excutable {
    
    /**
     Initialize a shared object with a DispatchQueue.global(qos: .userInitiated)
     - use this shared object in loading Api Request
     
     */
    public static var shared: NetworkRouter {
        let manger = NetworkRouter(queue: DispatchQueue.global(qos: .userInitiated))
        return manger
    }
    
    private var queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    
    private init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    func request<T: Codable> (
        request: NetworkRequest,
        complation _complation: @escaping (NetworkResponse<T>)->()
    ) {
        
        let complation: (NetworkResponse<T>)->() = { responce in
            DispatchQueue.main.async { _complation(responce) }
        }

        ApiSessionManager
            .sessionManager
            .request(request)
            .validate()
            .responseJSON
            { (responce) in
                complation(NetworkResponse(responce))
            }
    }
    
    
    func requestMultipart<T: Codable> (
        request: NetworkRequest,
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
                    if let parameters = request.parameters {
                        for (key, value) in parameters{
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: "\(key)")
                        }
                    }
                    request.multiPart?.forEach({ (multipart) in
                        multipartFormData.append(multipart.fileData, withName: multipart.fileName, fileName: multipart.fileData.format.fileName, mimeType: multipart.fileData.format.mimeType)
                    })
                },with: request).responseJSON(completionHandler: { (response) in
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
