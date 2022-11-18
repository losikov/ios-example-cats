//
//  Cat.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

import Foundation

struct Cat {
    let id: String
    let tags: [String]
}

extension Cat: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags
    }
}
