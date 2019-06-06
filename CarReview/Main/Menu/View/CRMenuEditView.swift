//
//  CRMenuEditView.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/13.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CRMenuEditView: CDBaseView {

    lazy var nameView = UIView().then({
        $0.backgroundColor = UIColor.ctrlBgColor()
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    })
    
    lazy var uidView = UIView().then({
        $0.backgroundColor = UIColor.ctrlBgColor()
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    })
    
    lazy var nameLab : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryColor()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "名称"
        return label
    }()
    
    lazy var uidLab : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryColor()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "编码:"
        return label
    }()
    
    lazy var nameText: UITextField = {
        let text = UITextField.init()
        text.font = UIFont.systemFont(ofSize: 20)
        text.keyboardAppearance = .dark
        text.textColor = .white
        text.becomeFirstResponder()
        return text
    }()
    
    lazy var uidText: UITextField = {
        let text = UITextField.init()
        text.keyboardType = UIKeyboardType.asciiCapable
        text.font = UIFont.systemFont(ofSize: 20)
        text.keyboardAppearance = .dark
        text.textColor = .white
        return text
    }()
    
    lazy var pointLab : UILabel = {
        let label = UILabel()
        label.textColor = .primaryColor()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "*提示:编码区分大小写"
        return label
    }()
    
    override func configUI() {
        
        addSubview(nameView)
        nameView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.height.equalTo(60)
        }
        
        addSubview(uidView)
        uidView.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.height.equalTo(60)
        }
        
        nameView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(50)
        }
        
        uidView.addSubview(uidLab)
        uidLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(50)
        }
        
        nameView.addSubview(nameText)
        nameText.snp.makeConstraints {
            $0.left.equalTo(nameLab.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.bottom.equalToSuperview()
        }
        
        uidView.addSubview(uidText)
        uidText.snp.makeConstraints {
            $0.left.equalTo(uidLab.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.bottom.equalToSuperview()
        }
        
        addSubview(pointLab)
        pointLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(uidView.snp.bottom).offset(5)
        }
        
    }
    
}
