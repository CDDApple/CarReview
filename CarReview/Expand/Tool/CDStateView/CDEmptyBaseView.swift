//
//  CDEmptyBaseView.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/29.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit

typealias ActionBtnBlock = ()->Void

class CDEmptyBaseView: UIView {

    let subViewMargin = 10.0
    
    let iconWidth = 40.0
    let iconHeight = 40.0
    let iconTopOffset = 80.0
    
    let titleLabFont = UIFont.systemFont(ofSize: 14)
    let descLabFont = UIFont.systemFont(ofSize: 12)
    
    let leftRightMargin = 80.0
    
    let actionBtnFont = UIFont.systemFont(ofSize: 14)
    let actionBtnWidth = 120.0
    let actionBtnHeight = 40.0
    
    var isHideActionBtn : Bool = false {
        didSet {
            actionBtn.isHidden = isHideActionBtn
        }
    }
    
    var iconImageName : String? {
        didSet{
            guard let name = iconImageName else {return}
            iconImageView.image = UIImage(named: name)
        }
    }
    
    var titleStr : String? {
        didSet{
            titleLab.text = titleStr
        }
    }
    
    var descStr : String? {
        didSet{
            descriptionLable.text = descStr
        }
    }
    
    var actionBtnBlock: ActionBtnBlock?
    
    private lazy var iconImageView : UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        return iw
    }()
    
    private lazy var titleLab : UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 0;
        tl.font = UIFont.systemFont(ofSize: 16)
        tl.textColor = UIColor.white
        tl.textAlignment = .center
        return tl
    }()
    
    private lazy var descriptionLable : UILabel = {
        let dl = UILabel()
        dl.numberOfLines = 0;
        dl.font = UIFont.systemFont(ofSize: 14)
        dl.textColor = UIColor.gray
        dl.textAlignment = .center
        return dl
        
    }()
    
    private lazy var actionBtn : UIButton = {
        let ab = UIButton()
        ab.setTitle("重新加载", for: .normal)
        ab.setTitleColor(UIColor.white, for: .normal)
        ab.backgroundColor = UIColor.primaryColor()
        ab.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        ab.layer.cornerRadius = 4
        ab.layer.masksToBounds = true
        ab.addTarget(self, action: #selector(actionBtnClick), for: .touchUpInside)
        return ab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(iconWidth)
            $0.centerY.equalToSuperview().offset(-iconTopOffset)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.top.equalTo(iconImageView.usnp.bottom).offset(subViewMargin)
            $0.left.equalTo(self.usnp.left).offset(leftRightMargin)
            $0.right.equalTo(self.usnp.right).offset(-leftRightMargin)
        }
        
        self.addSubview(descriptionLable)
        descriptionLable.snp.makeConstraints {
            $0.top.equalTo(titleLab.usnp.bottom).offset(subViewMargin)
            $0.left.equalTo(self.usnp.left).offset(leftRightMargin)
            $0.right.equalTo(self.usnp.right).offset(-leftRightMargin)
        }
        
        self.addSubview(actionBtn)
        actionBtn.snp.makeConstraints {
            $0.top.equalTo(descriptionLable.usnp.bottom).offset(subViewMargin*2)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(actionBtnWidth)
            $0.height.equalTo(actionBtnHeight)
        }
    }
    
    func show() {
    }
    
    func actionBtnBlock(_ closure: @escaping ActionBtnBlock) {
        actionBtnBlock = closure
    }
    
    @objc func actionBtnClick() {
        guard let closure = actionBtnBlock else { return }
        closure()
    }

    

    
}
