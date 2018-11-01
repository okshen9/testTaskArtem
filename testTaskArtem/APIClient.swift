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
    
    func getAnnotations(strImage: String, completion: @escaping ([AnnotationLabel]?, NSError?) -> ()) {
        
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
                if response.response?.statusCode == 200 {
                    guard  let annotations = try? JSONDecoder().decode(AnnotationResponse.self, from: response.data!)  else {
                        completion(nil, NSError(domain: "Не удалось понять ответ", code: 0, userInfo: nil))
                        return
                    }
                    completion(annotations.responses.first?.labelAnnotations, nil)
                }
                else if response.response?.statusCode == 403 {
                   completion(nil, NSError(domain: "Проблема с аунтификацией", code: 403, userInfo: nil))
                } else if response.response?.statusCode == 400 {
                    completion(nil, NSError(domain: "Слишком большое фото", code: 400, userInfo: nil))
                } else if response.response?.statusCode == nil {
                    completion(nil, NSError(domain: "Не удалось подключиться", code: 404, userInfo: nil))
                } else {
                    completion(nil, NSError(domain: "Что-то пошло не так", code: -1, userInfo: nil))
                }
        }
    }
}
