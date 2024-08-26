//
//  ToDoJSON.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 26.08.2024.
//

import Foundation

struct TodoResponse: Codable {
    let todos: [Todo]

    struct Todo: Codable {
        let id: Int
        let todo: String
        let completed: Bool
        let userId: Int
    }
}
