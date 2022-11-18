//
//  CatsFeedViewModel.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

import Foundation

let catsEndpoint = "https://cataas.com"

extension Cat {
    func imageUrl() -> String {
        return "\(catsEndpoint)/cat/\(id)?w=200&h=200"
    }
}

class CatsFeedViewModel {
    static let cellIdentifier = "CatsFeedCollectionViewCell"
    
    let title = "Cats"
    
    var items: [Cat] = []
    
    var reloadCollectionViewClosure: (()->())?
    var showAlertClosure: ((String)->())?
    
    func initFetch() {
        APIService().fetch(for: "\(catsEndpoint)/api/count") {
            [weak self] (response: APIResponse<CatsCount>) in
            switch response {
            case .error(let error):
                print("Error: '\(error)'.")
                self?.showAlertClosure?(error.localizedDescription)
            case .data(let data):
                let number = data.number
                
                APIService().fetch(for: "\(catsEndpoint)/api/cats?limit=\(number)") {
                    [weak self] (response: APIResponse<[Cat]>) in
                    switch response {
                    case .error(let error):
                        print("Error: '\(error)'.")
                        self?.showAlertClosure?(error.localizedDescription)
                    case .data(let data):
                        self?.items = data
                        self?.reloadCollectionViewClosure?()
                    }
                }
            }
        }
    }
}
