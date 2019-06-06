//
//  CDLoadingView.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/28.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit
import Lottie

class CDLoadingView: UIView {

    private lazy var activityview : UIActivityIndicatorView = {
        let  av = UIActivityIndicatorView()
        av.activityIndicatorViewStyle = .gray
        self.addSubview(av)
        av.snp.makeConstraints{
            $0.center.equalTo(self.usnp.center)
            $0.width.height.equalTo(30)
        }
        return av
    }()
    
    private lazy var animationView : AnimationView = {
        let av = AnimationView(name: "simple_loader")
        av.contentMode = .scaleAspectFill
//        av.loopAnimation = true

        return av
    }()
    
    private lazy var titleLab : UILabel = {
        let tl = UILabel()
        tl.text = "加载中..."
        tl.textColor = UIColor.gray
        tl.font = UIFont.systemFont(ofSize: 10)
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        self.addSubview(animationView)
        animationView.snp.makeConstraints{
            $0.center.equalTo(self.usnp.center)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints{
            $0.top.equalTo(animationView.usnp.bottom)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func startAnimation() {
        animationView.play()
    }
    
    func stopAnimation() {
        animationView.stop()
    }
}
