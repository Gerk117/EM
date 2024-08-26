//
//  ToDoPresenter.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 26.08.2024.
//

import Foundation

final class ToDoPresenter {
    
    private weak var view : ToDoView?
    
    init(view: ToDoView) {
        self.view = view
    }
    
    func lolkek(){
        print(Int.random(in: 1...10))
    }
    
}

// "https://dummyjson.com/todos"
