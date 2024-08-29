//
//  ToDoCoredata.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 27.08.2024.
//

import CoreData
import UIKit

final class ToDoCoreData {
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func createNewTask(todo:String){
        let task = ToDoTasks(context: context)
        task.completed = false
        task.date = Date()
        task.todo = todo
        task.id = Int16(generateUniqueId())
        try? saveContext()
    }
    
    func createDataTasks(models: [ToDoModel]) {
        let date = DateFormatter()
        date.dateStyle = .short
        for model in models {
            let task = ToDoTasks(context: context)
            task.completed = model.completed
            task.date = date.date(from: model.dateOfCreate)
            task.todo = model.todo
            task.id = Int16(model.id)
        }
        try? saveContext()
    }
    
    func returnToDoTasksModels() -> [ToDoModel]{
        let request = ToDoTasks.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let date = DateFormatter()
        date.dateStyle = .short
        guard let tasks = try? context.fetch(request) else{
            return []
        }
        let models = tasks.map { ToDoModel(id: Int($0.id),
                                           todo: $0.todo ?? "" ,
                                           completed: $0.completed,
                                           userId: 1,
                                           dateOfCreate: date.string(for: $0.date) ?? "" )
        }
        return models
    }
    
    func changeTask(newTodoTask: String, taskId: Int){
        guard let task = fetchTask(taskId: taskId) else {
            return
        }
        task.todo = newTodoTask
        try? self.saveContext()
    }
    
    func completeTask(taskId: Int){
        guard let task = fetchTask(taskId: taskId) else {
            return
        }
        task.completed = !task.completed
        try? self.saveContext()
    }
    
    func deleteTask(taskId : Int){
        guard let task = fetchTask(taskId: taskId) else {
            return
        }
        context.delete(task)
        try? self.saveContext()
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
    private func fetchTask(taskId: Int) -> ToDoTasks? {
        let request = ToDoTasks.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", taskId as CVarArg)
        request.predicate = predicate
        guard let task = try? context.fetch(request).first else {
            return nil
        }
        return task
    }
    
    
    private func generateUniqueId() -> Int {
        var newId = Int.random(in: 1...32767)
        while taskExists(withId: newId) {
            newId = Int.random(in: 1...32767)
        }
        return newId
    }
    
    private func taskExists(withId id: Int) -> Bool {
        let request = ToDoTasks.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        guard let tasks = try? context.fetch(request) else {
            return false
        }
        return !tasks.isEmpty
    }
    
}
