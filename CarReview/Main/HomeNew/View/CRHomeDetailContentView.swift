//
//  CRHomeDetailContentView.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/8.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CRHomeDetailContentView: UIScrollView {

    var didTopicBtn : (()->())?
    
    lazy var contentView = UIView().then({
        $0.backgroundColor = UIColor.clear
    })
    
    lazy var titleView = CRHomeListTitleView().then({
        $0.backgroundColor = UIColor.ctrlBgColor()
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    })
    
    lazy var topicBgView = UIButton().then({
        $0.backgroundColor = UIColor(r: 48, g: 59, b: 74)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(topicBtnClick), for: .touchUpInside)
    })
    
    lazy var moreImage = UIImageView().then({
        $0.image = UIImage(named: "more")
    })
    
    lazy var topicLab = UILabel().then({
        $0.textColor = UIColor.primaryColor()
        $0.font = UIFont(name: "PingFangSC-Semibold", size: 24)
        $0.text = "Topic"
    })
    
    lazy var nameLab = UILabel().then({
        $0.textColor = UIColor.primaryColor()
        $0.font = UIFont(name: "PingFangSC-Semibold", size: 40)
        $0.text = ""
    })
    
    lazy var infoLab = UILabel().then({
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.text = ""
        $0.numberOfLines = 0
    })
    
    lazy var viewNumLab = UILabel().then({
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.text = "视频播放数:0"
        $0.numberOfLines = 0
    })
    
    lazy var fansNumLab = UILabel().then({
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.text = "粉丝数:0"
        $0.numberOfLines = 0
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalTo(screenWidth)
        }
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
        }
        
        contentView.addSubview(topicBgView)
        topicBgView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.height.equalTo(40)
        }
        
        topicBgView.addSubview(moreImage)
        moreImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-10)
            $0.width.equalTo(6)
            $0.height.equalTo(18)
        }
        
        topicBgView.addSubview(topicLab)
        topicLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(moreImage.snp.left).offset(-10)
        }

        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalTo(topicBgView.snp.top)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalTo(topicLab.snp.left).offset(-5)
        }
        
        contentView.addSubview(infoLab)
        infoLab.snp.makeConstraints {
            $0.top.equalTo(topicBgView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(viewNumLab)
        viewNumLab.snp.makeConstraints {
            $0.top.equalTo(infoLab.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(fansNumLab)
        fansNumLab.snp.makeConstraints {
            $0.top.equalTo(viewNumLab.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        contentView.snp.makeConstraints({ (m) in
            m.bottom.equalTo(infoLab.snp.bottom).offset(0)
        })
    }
    
    var model : CRContentModel? {
        didSet {
            guard let model = model else {return}
            titleView.model = model
        }
    }
    
    var homeModel : CRHomeModel? {
        didSet {
            guard let homeModel = homeModel else { return }
            nameLab.text = homeModel.name
            infoLab.text = homeModel.desc
            viewNumLab.text = "视频播放数:" + homeModel.viewNum
            fansNumLab.text = "粉丝数:" + homeModel.fansNum
        }
    }
    
    @objc func topicBtnClick() {
        self.didTopicBtn?()
    }

}
