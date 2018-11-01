//
//  ExtensionUIImage.swift
//  testTaskArtem
//
//  Created by Артём Нешко on 01/11/2018.
//  Copyright © 2018 Артём Нешко. All rights reserved.
//

//import Foundation
import UIKit

extension UIImage {
    func getScaledImageData() -> Data?{
        let maxSize = 6660000.0
        let currentSize = Double(self.size.height) * Double(self.size.width)
        var scale = 1.0
        if currentSize > maxSize {
            scale = maxSize / currentSize
        }
        return self.jpegData(compressionQuality: CGFloat(scale))
    }
}
