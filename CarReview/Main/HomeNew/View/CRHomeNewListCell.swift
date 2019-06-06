//
//  CRHomeNewListCell.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/5.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CRHomeNewListCell: CDBaseTableViewCell {

    lazy var bgView = UIView().then({
        $0.backgroundColor = UIColor.ctrlBgColor()
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    })
    
    lazy var coverImage = UIImageView().then({
        $0.image = UIImage(named: "")
    })
    
    lazy var longTimeLab : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = " 00:00 "
        label.textAlignment = .center
        label.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.8)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var titleView = CRHomeListTitleView().then({
        $0.backgroundColor = UIColor.ctrlBgColor()
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    })
    
    lazy var playImage = UIImageView().then({
        $0.image = UIImage(named: "play_new")
    })

    override func configUI() {
        
        backgroundColor = .clear
        
        let H = ((screenWidth - 10) * 9) / 16
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview()
        }
        
        bgView.addSubview(coverImage)
        coverImage.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(H)
        }
        
        bgView.addSubview(longTimeLab)
        longTimeLab.snp.makeConstraints {
            $0.bottom.right.equalTo(coverImage).offset(-7)
            $0.height.equalTo(18)
        }
        
        bgView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(coverImage.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        bgView.addSubview(playImage)
        playImage.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().offset(-7)
            $0.width.height.equalTo(25)
        }
        
    }
    
    var model : CRContentModel? {
        didSet {
            guard let model = model else {return}
            coverImage.kf.setImage(urlString: model.videoCover)
            longTimeLab.text = " \(model.videoLongTime)  "
            titleView.model = model
        }
    }
    
    var topicModel : CRTopicDataModel? {
        didSet {
            guard let model = topicModel else {return}
            
            let thumbnail = model.thumbnail.replacingOccurrences(of: "0542", with: "0541")
            
            coverImage.kf.setImage(urlString: thumbnail)
            titleView.titleLab.text = model.title
            longTimeLab.text = " \(model.fmt_duration)  "
        }
    }
}
