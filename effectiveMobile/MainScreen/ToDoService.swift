//
//  ToDoService.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 26.08.2024.
//

import Foundation

protocol LoadToDoService {
    func loadToDo(completion: @escaping ([ToDoModel]) -> Void)
}

final class ToDoService : LoadToDoService {
    
    func loadToDo(completion: @escaping ([ToDoModel]) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        let date = DateFormatter()
        date.dateStyle = .short
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            var resultData = [ToDoModel]()
            guard let data else { completion([])
                return }
            do {
                let result = try decoder.decode(ToDoJSON.self, from: data)
                for i in result.todos {
                    resultData.append(ToDoModel(id: i.id,
                                                todo: i.todo,
                                                completed: i.completed,
                                                userId: i.userId,
                                                dateOfCreate: date.string(from: Date())))
                }
                completion(resultData)
            } catch {
                completion([])
            }
        }.resume()
    }
    
}
