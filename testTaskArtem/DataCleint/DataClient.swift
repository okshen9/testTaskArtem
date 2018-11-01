//
//  DataClient.swift
//  testTaskArtem
//
//  Created by Артём Нешко on 01/11/2018.
//  Copyright © 2018 Артём Нешко. All rights reserved.
//

import Foundation
import UIKit



class DataClient {
    static let shared = DataClient()
    
    func getAnnotations (image: UIImage?, completion: @escaping ([AnnotationLabel]?, NSError?) -> ()){
        
        guard let imageData:NSData = image?.getScaledImageData() as NSData? else {
            return
        }
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
                APIClient.shared.getAnnotations(strImage: imageStr) { (annotation, error) in
                    completion(annotation, error)
                }
    }
}
