//
//  NewMockDataService.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Grant Watson on 5/23/22.
//

import Combine
import Foundation
import SwiftUI

protocol NewDataServiceProtocol {
    
    func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> ())
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error>
}

class NewMockDataService: NewDataServiceProtocol {
    
    let items: [String]
    
    init(items: [String]?) {
        self.items = items ?? [
        "ONE", "TWO", "THREE"
        ]
    }
    
    func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(self.items)
        }
    }
    
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error> {
        Just(items)
            .tryMap({ publishedItems in
                guard !publishedItems.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return publishedItems
            })
            .eraseToAnyPublisher()
    }
}
