//
//  APIClient.swift
//  testTaskArtem
//
//  Created by Артём Нешко on 31/10/2018.
//  Copyright © 2018 Артём Нешко. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    static let shared = APIClient()
    
    private let baseURL: String
    
    init() {
        let apiKey = "AIzaSyAc4bL_u2u9pVxtzKX9DAFrVh4A_knLmWE"
        baseURL =  "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)"
    }
    
    func getAnnotations(strImage: String, completion: @escaping (DataResponse<Any>) -> ()) {
        
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": "\(strImage)"
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        ]
                ]
            ]
        ]

        Alamofire.request(self.baseURL, method: .post, parameters: jsonRequest, encoding: JSONEncoding.default, headers: nil).responseJSON
            { (response) in
                completion(response)
        }
    }
}
