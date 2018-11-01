//
//  DataClient.swift
//  testTaskArtem
//
//  Created by Артём Нешко on 01/11/2018.
//  Copyright © 2018 Артём Нешко. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DataClient {
    static let shared = DataClient()
    
    func getAnnotations (image: UIImage?, completion: @escaping ([AnnotationLabel]?, NSError?) -> ()){
        
        guard let imageData:NSData = image?.getScaledImageData() as NSData? else {
            return
        }
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
                APIClient.shared.getAnnotations(strImage: imageStr) { (response) in
                    
                    if response.response?.statusCode == 200 {
                        guard  let annotations = try? JSONDecoder().decode(AnnotationResponse.self, from: response.data!)  else {
                            completion(nil, NSError(domain: "Не удалось понять ответ", code: 0, userInfo: nil))
                            return
                        }
                        completion(annotations.responses.first?.labelAnnotations, nil)
                    }
                    else if response.response?.statusCode == 403 {
                        completion(nil, NSError(domain: "Проблема с аутентификация", code: 403, userInfo: nil))
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
