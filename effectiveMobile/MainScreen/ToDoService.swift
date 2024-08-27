//
//  ToDoService.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 26.08.2024.
//

import Foundation

protocol LoadToDoService {
    func loadToDo(completion: @escaping ([ToDo]) -> Void)
}

final class ToDoService : LoadToDoService {
    
    func loadToDo(completion: @escaping ([ToDo]) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            
            guard let data else { completion([])
                return }
            do {
                let result = try decoder.decode(ToDoJSON.self, from: data)
                completion(result.todos)
            } catch {
                completion([])
            }
        }.resume()
    }
    
}
