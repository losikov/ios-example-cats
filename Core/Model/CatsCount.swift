//
//  CatsCount.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

import Foundation

struct CatsCount {
    let number: Int
}

extension CatsCount: Decodable {
    enum CodingKeys: String, CodingKey {
        case number
    }
}
