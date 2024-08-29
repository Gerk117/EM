//
//  ToDoCell.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 25.08.2024.
//

import UIKit
import SnapKit

protocol ToDoCellDelegate : AnyObject {
    func changeToDo(index:IndexPath)
}

final class ToDoCell : UITableViewCell {
    
    var indexPath : IndexPath?
    
    weak var delegate : ToDoCellDelegate?
    
    private var completeStatus : Bool = false
    
    private var label : UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.sizeToFit()
        return label
    }()
    
    private var completeImage : UIImageView = {
        var image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    private var dateOfCreate : UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.sizeToFit()
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model : ToDoModel){
        label.text = model.todo
        completeStatus = model.completed
        completeImage.image = model.completed ?  UIImage(systemName: "checkmark") : UIImage(systemName: "xmark")
        completeImage.tintColor = completeStatus ? .green : .red
        dateOfCreate.text = "Создано: \(model.dateOfCreate)"
        setupScreen()
        addInteraction(UIContextMenuInteraction(delegate: self))
    }
    
    
    private func setupScreen(){
        contentView.addSubview(label)
        contentView.addSubview(completeImage)
        contentView.addSubview(dateOfCreate)
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(dateOfCreate.snp_topMargin).offset(-5)
            $0.right.equalTo(completeImage.snp.left).offset(-5)
            $0.left.equalToSuperview().offset(5)
        }
        completeImage.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        dateOfCreate.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-2)
            $0.height.equalTo(12)
        }
    }
    
}

extension ToDoCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let menu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let action = UIAction(title: "Редактировать", image: nil) { _ in
                if let index = self?.indexPath  {
                    self?.delegate?.changeToDo(index:index)
                }
            }
            return UIMenu(title: "", children: [action])
        }
        return menu
    }
}
