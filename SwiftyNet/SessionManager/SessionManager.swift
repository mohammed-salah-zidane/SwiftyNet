//
//  SessionManager.swift
//  SwiftyNet
//
//  Created by prog_zidane on 4/29/21.
//

import Foundation
import Alamofire

final class ApiSessionManager: NSObject {
    
    private static var manager: Session?
    public static var sessionManager: Session {
        get {
            if manager == nil {
                manager = Session(configuration: Session.default.sessionConfiguration,interceptor: Interceptor())
            }
            return manager!
        }
    }
    
    private override init() {
        super.init()
    }
    /// Use for update the header to contain token
    /// Use this func after every Login (after success validation with the server)
    static func cancelAllRequests() {
        manager = nil
        // it will automaticaly invalidateAndCancel()
    }
    deinit {
        ApiSessionManager.cancelAllRequests()
    }
}
