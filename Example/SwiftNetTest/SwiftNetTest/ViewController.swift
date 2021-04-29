//
//  ViewController.swift
//  SwiftNetTest
//
//  Created by prog_zidane on 4/29/21.
//

import UIKit
import SwiftyNet

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = UsersRequests.getUsers
        let router = NetworkRouter()
        
        router.request(
                targetRequest: request,
                responseObject: BaseResponse<[UserModel]>.self
        ) { result in
            switch result {
            case .success(let data):
                print(data.data?.count)
            case .failure(let error):
                print(error.errorDescription)
            @unknown default:
                fatalError()
            }
        }
    }
}

