//
//  APIRequester.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

import Foundation

class APIService {
    /// Make an API reqeust and returns the data
    /// Safe to call multiple times with the same arguments, as it won't make extra API calls.
    /// - parameter url: string URL
    /// - parameter completionHandler: pass **APIResponse<DataResponse: Decodable>**
    final func fetch<DataResponse: Decodable>(
        for url: String,
        completionHandler: @escaping (APIResponse<DataResponse>) -> Void
    ) {
        URLSession.shared.dataTask(with: URL(string: url)!) { [] (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(APIResponse.error(error))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data
            else {
                completionHandler(APIResponse.error(APIError.invalidAPIResponse))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(DataResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(APIResponse.data(json))
                }
            } catch let error as NSError {
                print("Failed to parse response: '\(error)'")
                completionHandler(APIResponse.error(error))
                return
            }
        }.resume()
    }
}
