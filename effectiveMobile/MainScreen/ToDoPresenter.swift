//
//  ToDoPresenter.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 26.08.2024.
//

import Foundation

protocol ToDoPresenterProtocol {
    func loadData()
    func updateView()
    func changeName(at index : IndexPath,newName : String)
    var dataResult : [ToDo] {get}
}

final class ToDoPresenter : ToDoPresenterProtocol {
   
    var dataResult: [ToDo] {
        toDoData
    }
    
    private var toDoService : LoadToDoService = ToDoService()
    private var toDoData = [ToDo]()
    private weak var view : ToDoViewProtocol?
    
    init(view: ToDoView) {
        self.view = view
    }
    
    func loadData(){
        DispatchQueue.main.async {
            self.toDoService.loadToDo {
                self.toDoData = $0
                self.updateView()
            }
        }
    }
    
    func updateView(){
        view?.updateTable()
    }

    func changeName(at index : IndexPath,newName : String){
        toDoData[index.row].todo = newName
        updateView()
    }
}
