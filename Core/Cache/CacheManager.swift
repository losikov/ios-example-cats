//
//  CacheStorage.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

import Foundation

// MARK: - Storage Configuration

let memoryCapacity = 100 * 1024 * 1024
let diskCapacity = 500 * 1024 * 1024
let diskPath = "com.pbsco.cats"

class CacheManager {
    public static let shared = CacheManager()
    
    let cacheStorage = URLCache(
        memoryCapacity: memoryCapacity,
        diskCapacity: diskCapacity,
        diskPath: diskPath
    )
    
    private init() {
    }
    
    private static func request(for urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    func retrieve(string urlString: String) -> Data? {
        guard
            let request = CacheManager.request(for: urlString),
            let cachedUrlResponse = cacheStorage.cachedResponse(for: request)
        else {
            return nil
        }
        
        return cachedUrlResponse.data
    }
    
    func store(string urlString: String, response: URLResponse?, data: Data?) {
        guard
            let request = CacheManager.request(for: urlString),
            let url = URL(string: urlString),
            let data = data
        else {
            return
        }
        
        let urlResponse = URLResponse(
            url: url,
            mimeType: nil,
            expectedContentLength: data.count,
            textEncodingName: nil
        )
        let cachedURLResponse = CachedURLResponse(response: urlResponse, data: data)
        cacheStorage.storeCachedResponse(cachedURLResponse, for: request)
    }
}
