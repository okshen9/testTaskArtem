//
//  CodableStract.swift
//  testTaskArtem
//
//  Created by Артём Нешко on 31/10/2018.
//  Copyright © 2018 Артём Нешко. All rights reserved.
//

import Foundation

struct AnnotationLabel: Codable {
    var mid: String
    var description: String
    var score: Double
}

struct Annotations: Codable {
    var labelAnnotations: [AnnotationLabel]
}

struct AnnotationResponse: Codable {
    var responses: [Annotations]
}
