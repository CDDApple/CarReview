//
//  CRHomeTopicCell.swift
//  CarReview
//
//  Created by caodd on 2018/9/9.
//  Copyright © 2018年 CarReview. All rights reserved.
//

import UIKit

class CRHomeTopicCell: CDBaseTableViewCell {

    
    lazy var contentV = UIImageView().then({
        $0.backgroundColor = UIColor.ctrlBgColor()
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    })

    lazy var coverImageV = UIImageView().then({
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "topic_cover")
    })

    lazy var titleLab = UILabel().then({
        $0.text = "车展视频"
        $0.textColor = UIColor.white
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.numberOfLines = 3
    })
    
    lazy var videoCountLab = UILabel().then({
        $0.text = "视频:18"
        $0.textColor = UIColor.shadowColor()
        $0.font = UIFont.systemFont(ofSize: 14)
    })
    
    lazy var playCountLab = UILabel().then({
        $0.text = "播放:707"
        $0.textColor = UIColor.shadowColor()
        $0.font = UIFont.systemFont(ofSize: 14)
    })
    
    
    lazy var topicLab = UILabel().then({
        $0.text = "专题"
        $0.textColor = UIColor.white
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.backgroundColor = UIColor.primaryColor()
        $0.textAlignment = .center
    })
    
    override func configUI() {
        
        backgroundColor = UIColor.backgroudColor
        
        let H = 200 //((screenWidth - 20) * 9) / 16 + 10
        contentView.addSubview(contentV)
        contentV.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.height.equalTo(H)
            $0.bottom.equalToSuperview()
        }
        
        contentV.addSubview(coverImageV)
        coverImageV.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
        
        coverImageV.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-5)
        }
        
        coverImageV.addSubview(videoCountLab)
        videoCountLab.snp.makeConstraints {
            $0.top.equalTo(titleLab.snp.bottom).offset(20)
            $0.left.right.equalTo(titleLab)
        }
        
        coverImageV.addSubview(playCountLab)
        playCountLab.snp.makeConstraints {
            $0.top.equalTo(videoCountLab.snp.bottom).offset(10)
            $0.left.right.equalTo(titleLab)
        }
        
        contentV.addSubview(topicLab)
        topicLab.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(20)
        }
        
        
    }
    
    var model : CRTopicListModel? {
        didSet {
            guard let model = model else {return}
            contentV.kf.setImage(urlString: model.coverImage)
            titleLab.text = model.title
            videoCountLab.text = "视频:\(model.videoNum)"
            playCountLab.text = "播放:\(model.playNum)"
        }
    }
    
}
