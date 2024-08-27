//
//  ToDoCell.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 25.08.2024.
//

import UIKit
import SnapKit



final class ToDoCell : UITableViewCell {
    
    private var label : UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
 
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScreen(){
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
    func config(toDoText : String){
        label.text = toDoText
        setupScreen()
    }
    
}
