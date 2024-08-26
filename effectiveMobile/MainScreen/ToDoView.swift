//
//  ViewController.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 24.08.2024.
//

import UIKit
import SnapKit

class ToDoView: UIViewController {
    
    private var data = [[1,2,3],[3,4,5],[6,7,8,9]]
    
    private var presenter : ToDoPresenter?
    
    private var table: UITableView = {
        var table = UITableView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ToDoPresenter(view: self)
        table.dataSource = self
        table.delegate = self
        table.register(ToDoCell.self, forCellReuseIdentifier: "ToDoCell")
        setupScreen()
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
       return data.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ["lol","kek","azaza"][section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "ToDoCell") as? ToDoCell else {
            return UITableViewCell() }
        cell.config(number: data[indexPath.section][indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.lolkek()
    }
    
}
