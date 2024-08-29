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
    func reloadRow(index:IndexPath)
    func removeIndicator()
}

final class ToDoView: UIViewController, ToDoViewProtocol {
    
    private var presenter : ToDoPresenterProtocol?
    
    private var lastContentOffset: CGFloat = 0
    private var longPressIndexPath: IndexPath?
    
    private var table: UITableView = {
        var table = UITableView()
        return table
    }()
    private var activityIndicator : UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var addButton : UIButton = {
        var button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 4
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            let alert = UIAlertController(title: "Новая Задача", message: nil, preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "Создать", style: .default , handler: { [weak self] _ in
                self?.presenter?.createTask(todo: alert.textFields?[0].text ?? "")
            }))
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil ))
            self.present(alert, animated: true)
        }), for: .touchUpInside)
        return button
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
    func removeIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func updateTable() {
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func reloadRow(index:IndexPath) {
        table.reloadRows(at: [index], with: .automatic)
    }
    
    private func setupScreen(){
        view.backgroundColor = .white
        view.addSubview(table)
        view.addSubview(addButton)
        view.addSubview(activityIndicator)
        table.rowHeight = 65
        table.snp.makeConstraints {
            $0.top.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
        }
        addButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-100)
            $0.width.height.equalTo(50)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
}

extension ToDoView : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.toDoData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "ToDoCell") as? ToDoCell else {
            return UITableViewCell() }
        guard let model = presenter?.toDoData[indexPath.row] else {
            return UITableViewCell() }
        cell.config(model: model)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presenter?.updateCompleteStatus(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.presenter?.deleteTask(index: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset > lastContentOffset {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
        lastContentOffset = currentOffset
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.addButton.isHidden = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            addButton.alpha = 0
            addButton.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.addButton.alpha = 1
            }
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset < lastContentOffset {
            addButton.isHidden = false
            addButton.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.addButton.alpha = 1
            }
        }
    }
}

extension ToDoView : ToDoCellDelegate {
    
    
    func changeToDo(index: IndexPath) {
        let alert = UIAlertController(title: "Редактировать", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Применить", style: .default , handler: { [weak self] _ in
            let text = alert.textFields?[0].text ?? ""
            self?.presenter?.changeTask(index: index , task: text)
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil ))
        self.present(alert, animated: true)
    }
}
