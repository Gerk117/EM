//
//  ViewController.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 24.08.2024.
//

import UIKit
import SnapKit

protocol ToDoViewProtocol : AnyObject {
    func updateTable()
}

final class ToDoView: UIViewController, ToDoViewProtocol {
    
    private var presenter : ToDoPresenterProtocol?
    
    private var table: UITableView = {
        var table = UITableView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ToDoPresenter(view: self)
        presenter?.loadData()
        table.dataSource = self
        table.delegate = self
        table.register(ToDoCell.self, forCellReuseIdentifier: "ToDoCell")
        setupScreen()
    }
    
    func updateTable() {
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    private func setupScreen(){
        view.backgroundColor = .white
        view.addSubview(table)
        table.rowHeight = 50
        table.snp.makeConstraints {
            $0.top.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ToDoView : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.dataResult.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "ToDoCell") as? ToDoCell else {
            return UITableViewCell() }
        cell.config(toDoText: presenter?.dataResult[indexPath.row].todo ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
