//
//  CRHomeDetailViewController.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/8.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit
import AVKit

class CRHomeDetailViewController: CDBaseViewController {

    lazy var playView = CRHomeDetailPlayView().then({
        $0.backgroundColor = UIColor.ctrlBgColor()
        $0.didPlayBtn = { [weak self] (url) in
            let playVC = AVPlayerViewController()
            playVC.player = AVPlayer(url: URL(string: url)!)
            playVC.allowsPictureInPicturePlayback = true //这个是允许画中画的
            playVC.player?.play() //这里我设置直接播放,页面弹出后会直接播放,要不然还需要点击一下播放按钮
            self?.present(playVC, animated: true, completion: nil)
        }
    })
    
    lazy var backBtn = UIButton().then({
        $0.setImage(UIImage(named: "back"), for: .normal)
        $0.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
    })
    
    lazy var contentView = CRHomeDetailContentView().then({
        $0.backgroundColor = UIColor.clear
        $0.showsHorizontalScrollIndicator = false
        $0.didTopicBtn = { [weak self] in
            let detalVC = CRHomeNewTopicController()
            detalVC.model = self?.homeModel
            self?.navigationController?.pushViewController(detalVC, animated: true)
        }
    })
    
    var model : CRContentModel? {
        didSet {
            guard let model = model else { return }
            playView.model = model
            contentView.model = model
        }
    }
    
    var homeModel : CRHomeModel? {
        didSet {
            guard let homeModel = homeModel else { return }
            contentView.homeModel = homeModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = model?.videoTitle
    }
    
    override func configUI() {
        
        let H = (screenWidth * 9) / 16
        view.addSubview(playView)
        playView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(H)
        }
        
//        playView.addSubview(backBtn)
//        backBtn.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.left.equalToSuperview().offset(5)
//            $0.width.height.equalTo(44)
//        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(playView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
    }

//    override func needHiddenNavBar() -> Bool {
//        return true
//    }
    
    @objc private func backBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
