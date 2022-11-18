//
//  UIImageView+Cache.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

import UIKit

/// to prevent multiple loading of the same image, and store the closures for all callers to call them
private var imagesInProgress = [String: [(UIImage?) -> Void]]()

extension UIImageView {
    func loadImageWithUrl(
        string urlString: String,
        placeholder: UIImage?,
        startedHandler: () -> Void,
        completionHandler: @escaping (UIImage?) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        // check if the image in the cache
        if let data = CacheManager.shared.retrieve(string: urlString),
           let image = UIImage(data: data) {
            completionHandler(image)
            return
        }
        
        startedHandler()
        
        func completion(_ image: UIImage?) {
            DispatchQueue.main.async {
                imagesInProgress[urlString]?.forEach({ completionHandler in
                    completionHandler(image)
                })
            }
        }
        
        // check if the image is already loading
        if imagesInProgress[urlString] != nil {
            imagesInProgress[urlString]!.append(completionHandler)
            return
        } else {
            imagesInProgress[urlString] = [completionHandler]
        }
        
        // load the image
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to load image for '\(urlString)': \(error)")
                completion(placeholder)
                return
            }
            
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                print("Invalid image for '\(urlString)'")
                completion(placeholder)
                return
            }
            
            completion(image)
            
            CacheManager.shared.store(string: urlString, response: response, data: data)
        }.resume()
    }
}
