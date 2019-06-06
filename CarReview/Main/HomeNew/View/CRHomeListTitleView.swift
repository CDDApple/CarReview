//
//  CRHomeListTitleView.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/5.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CRHomeListTitleView: CDBaseView {
    
    lazy var titleLab : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var timeLab : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.secondaryColor()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = ""
        return label
    }()
    
    override func configUI() {
    
        addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
        }
        
        addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.top.equalTo(titleLab.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    var model : CRContentModel? {
        didSet {
            guard let model = model else {return}
            titleLab.text = model.videoTitle
            timeLab.text = model.videoTime
        }
    }
    
}
