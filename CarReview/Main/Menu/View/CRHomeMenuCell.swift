//
//  CRHomeMenuCell.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/11.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CRHomeMenuCell: CDBaseTableViewCell {

    lazy var nameLab : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "张大仙"
        return label
    }()
    
    override func configUI() {
        backgroundColor = UIColor.ctrlBgColor()
        
        addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.centerY.equalToSuperview()
        }
    }

    var model : CRHomeContentModel? {
        didSet {
            guard let model = model else { return }
            
            nameLab.text = model.name
        }
    }
}
