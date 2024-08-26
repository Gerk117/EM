//
//  ToDoCell.swift
//  effectiveMobile
//
//  Created by Георгий Ксенодохов on 25.08.2024.
//

import UIKit
import SnapKit


class ToDoCell : UITableViewCell {
    
    private var label : UILabel = {
        var label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupScreen(){
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            
        }
    }
    
    func config(number : Int){
        label.text = "\(number)"
        setupScreen()
    }
}
