//
//  EntryController.swift
//  SortListChallenge
//
//  Created by Leonardo Diaz on 9/10/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

class EntryController {
    //MARK: - Properties
    static private let baseURL = URL(string: "https://fetch-hiring.s3.amazonaws.com")
    static private let hiringPath = "hiring"
    static private let jsonExt = "json"
    
    static var sections = [Int]()
    

    //MARK: - Static Methods
    static func fetchEntries(completion: @escaping(Result<[[Entry]], SortListError>) -> Void) {
        // Endpoint https://fetch-hiring.s3.amazonaws.com/hiring.json
        guard let baseURL = baseURL else { return }
        let hiring = baseURL.appendingPathComponent(hiringPath)
        let finalURL = hiring.appendingPathExtension(jsonExt)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                let entries = try JSONDecoder().decode([Entry].self, from: data)
                let activeEntries = entries.filter({$0.name != nil && $0.name != ""})
                // Get section names and amount without duplicates
                let numberOfVariants = Set(activeEntries.map({ (id) -> Int in
                    id.listId
                }))
                // Sort the section ids acending
                sections = numberOfVariants.sorted()
                
                let sorted = activeEntries.sorted { (first, second) -> Bool in
                    first.id < second.id
                }
                
                var rows = [[Entry]]()
                // Create empty rows needed depending on the count
                for _ in 0..<EntryController.sections.count {
                    rows.append([])
                }
                // Iterate through rows and append entry at correct position
                for index in 0..<sections.count {
                    sorted.forEach({ (entry) in
                        if entry.listId == sections[index] {
                            rows[index].append(entry)
                        }
                    })
                }
                
                completion(.success(rows))
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
}
