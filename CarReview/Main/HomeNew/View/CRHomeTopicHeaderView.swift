//
//  CRHomeTopicHeaderView.swift
//  CarReview
//
//  Created by caodd on 2018/9/9.
//  Copyright © 2018年 CarReview. All rights reserved.
//

import UIKit

class CRHomeTopicHeaderView: UIView {

    var backClickBlock : (()->())?
    var logoImageVY :CGFloat = 0.0
    
    lazy var coverImageV = UIImageView().then({
        $0.contentMode = .scaleAspectFill
//        $0.image = UIImage(named: "banner.9c45ada96f")
        $0.layer.masksToBounds = true
        $0.blurView.setup(style: .light, alpha: 1).enable()
    })
    
    lazy var logoImageV = UIImageView().then({
        $0.image = UIImage(named: "")
    })
    
    lazy var titleLab = UILabel().then({
        $0.text = ""
        $0.textColor = UIColor.white
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    })
    
    lazy var descLab = UILabel().then({
        $0.text = ""
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 2
    })
    
    lazy var playNumLab = UILabel().then({
        $0.text = "视频播放数 : "
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 14)
    })
    
    lazy var fansNumLab = UILabel().then({
        $0.text = "粉丝数 : "
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 14)
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    lazy var backBtn = UIButton().then({
        $0.setImage(UIImage(named: "back"), for: .normal)
        $0.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
    })
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        layer.masksToBounds = true
        
        self.addSubview(coverImageV)
        coverImageV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(statusHeight)
            $0.left.equalToSuperview().offset(5)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        
        self.addSubview(fansNumLab)
        fansNumLab.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-15)
            $0.left.equalTo(screenWidth/2 + 10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        self.addSubview(playNumLab)
        playNumLab.snp.makeConstraints {
            $0.centerY.equalTo(fansNumLab)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(fansNumLab.snp.left).offset(-20)
        }

        self.addSubview(descLab)
        descLab.snp.makeConstraints {
            $0.bottom.equalTo(playNumLab.snp.top).offset(-15)
            $0.left.equalTo(playNumLab)
            $0.right.equalToSuperview().offset(-20)
        }


        self.addSubview(logoImageV)
        logoImageV.snp.makeConstraints {
            $0.bottom.equalTo(descLab.snp.top).offset(-15)
            $0.left.equalTo(playNumLab)
            $0.width.height.equalTo(55)
        }

        self.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.centerY.equalTo(logoImageV)
            $0.left.equalTo(logoImageV.snp.right).offset(10)
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if logoImageVY <= 0.0 {
            logoImageVY =  max(logoImageVY, logoImageV.y)
        }
        
    }
    
    var model : CRHomeModel? {
        didSet {
            guard let model = model else {return}
            coverImageV.kf.setImage(urlString: model.headfigure)
            titleLab.text = model.name
            logoImageV.kf.setImage(urlString: model.avatar)
            descLab.text = "简介 : \(model.desc)"
            playNumLab.text = "视频播放数 : \(model.viewNum)"
            fansNumLab.text = "粉丝数 : \(model.fansNum)"
        }
    }
    
    var progress : CGFloat? {
        didSet {
            guard let progress = progress else {return}
            
            
            if progress == 2 {
                logoImageV.snp.remakeConstraints {
                    $0.bottom.equalTo(descLab.snp.top).offset(-15)
                    $0.left.equalTo(playNumLab)
                    $0.width.height.equalTo(55)
                }
                return
            }
            let hideProgress = CGFloat(1 - progress)
            descLab.alpha = hideProgress
            fansNumLab.alpha = hideProgress
            playNumLab.alpha = hideProgress
            
            
            let WH = 55 - 25 * progress
            let Y = logoImageVY - ((logoImageVY - statusHeight + 5) * progress) + ((55 - WH) / 2)
            let X = 20 + 80 * progress + ((55 - WH) / 2)

            logoImageV.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(Y)
                $0.left.equalToSuperview().offset(X)
                $0.width.height.equalTo(WH)
            }
            let fontSize = 20 - 6 * progress
            titleLab.font = UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
    
    @objc func backBtnClick() {
        self.backClickBlock?()
    }
}
