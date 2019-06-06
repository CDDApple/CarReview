//
//  CRHomeDetailPlayView.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/8.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CRHomeDetailPlayView: CDBaseView {

    var didPlayBtn : ((_ url : String)->())?
    
    lazy var coverImage = UIImageView().then({
        $0.image = UIImage(named: "")
    })
    
    lazy var playImage = UIImageView().then({
        $0.image = UIImage(named: "play_new")
    })
    
    lazy var playBtn = UIButton().then({
        $0.addTarget(self, action: #selector(playBtnClick), for: .touchUpInside)
    })
    
    override func configUI() {
        

        addSubview(coverImage)
        coverImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(playImage)
        playImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        addSubview(playBtn)
        playBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    @objc func playBtnClick() {
        guard let model = model else {return}
        
        self.didPlayBtn?(model.videoeUrl)
    }
    
    var model : CRContentModel? {
        didSet {
            guard let model = model else {return}
            coverImage.kf.setImage(urlString: model.videoCover)
        }
    }

}
