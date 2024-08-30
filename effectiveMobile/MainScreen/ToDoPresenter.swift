//
//  ToDoPresenter.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 26.08.2024.
//

import Foundation

protocol ToDoPresenterProtocol {
    func loadData()
    func updateTable()
    func reloadRow(index:IndexPath)
    func updateCompleteStatus(index : IndexPath)
    func deleteTask(index : IndexPath)
    func changeTask(index: IndexPath, task:String)
    func createTask(todo:String)
    var toDoData : [ToDoModel] {get set}
}

final class ToDoPresenter : ToDoPresenterProtocol {
    
    
    
    var toDoData = [ToDoModel]()
    private var toDoService : LoadToDoService = ToDoService()
    private weak var view : ToDoViewProtocol?
    private var tasksCore = ToDoCoreData()
    
    init(view: ToDoView) {
        self.view = view
    }
    
    func loadData(){
        if !UserDefaults.standard.bool(forKey: "firstLunch") {
            DispatchQueue.global().async {
                self.toDoService.loadToDo {
                    self.tasksCore.createDataTasks(models: $0)
                    self.toDoData = self.tasksCore.returnToDoTasksModels()
                    self.updateTable()
                    DispatchQueue.main.async {
                        self.view?.removeIndicator()
                    }
                }
                UserDefaults.standard.setValue(true, forKey: "firstLunch")
            }
        } else  {
            toDoData = tasksCore.returnToDoTasksModels()
            self.updateTable()
            DispatchQueue.main.async {
                self.view?.removeIndicator()
            }
        }
    }
    
    func deleteTask(index : IndexPath){
        let model = toDoData[index.row]
        DispatchQueue.global().async {
            self.tasksCore.deleteTask(taskId: model.id)
        }
        toDoData.remove(at: index.row)
    }
    
    func changeTask(index: IndexPath, task:String){
        let model = toDoData[index.row]
        DispatchQueue.global().async {
            self.tasksCore.changeTask(newTodoTask: task, taskId: model.id)
            self.toDoData = self.tasksCore.returnToDoTasksModels()
            DispatchQueue.main.async {
                self.reloadRow(index: index)
            }
        }
    }
    
    func updateCompleteStatus(index : IndexPath){
        let model = toDoData[index.row]
        DispatchQueue.global().async {
            self.tasksCore.completeTask(taskId: model.id)
            self.toDoData = self.tasksCore.returnToDoTasksModels()
            DispatchQueue.main.async {
                self.reloadRow(index: index)
            }
        }
    }
    
    func createTask(todo:String){
        DispatchQueue.global().async {
            self.tasksCore.createNewTask(todo: todo)
            self.toDoData = self.tasksCore.returnToDoTasksModels()
            self.updateTable()
        }
    }
    func updateTable() {
        DispatchQueue.main.async {
            self.view?.updateTable()
        }
    }
    
    func reloadRow(index: IndexPath) {
        view?.reloadRow(index: index)
    }
    
}
