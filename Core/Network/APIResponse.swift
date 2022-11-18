//
//  APIResponse.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

/// Base structure for all API functions to return a result in a handler
enum APIResponse<DataType> {
    case data(DataType)
    case error(Error)
}
