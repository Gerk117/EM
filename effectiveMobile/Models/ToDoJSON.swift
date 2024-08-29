//
//  ToDoJSON.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 26.08.2024.
//

import Foundation

struct ToDoJSON : Codable {
    let todos : [ToDo]
}

struct ToDo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
