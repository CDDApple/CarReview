//
//  CDMainTabBarViewController.swift
//  SwiftBP
//
//  Created by caodd on 2018/7/23.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit
import SnapKit

class CDMainTabBarViewController: UITabBarController {

    private lazy var adImageView: UIImageView = {
        let adIw = UIImageView()
        adIw.contentMode = .scaleAspectFill
        view.addSubview(adIw)
        adIw.snp.makeConstraints{
            $0.left.right.top.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 1, animations: {
            adIw.transform =   CGAffineTransform(scaleX: 1.2, y: 1.2)
            adIw.alpha =   0
        }, completion: { _ in
            adIw.removeFromSuperview()
        })
        return adIw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 广告页
        adImageView.image = UIImage.getLaunchImage()
        
        addChildViewControllers()
    }
    
    private func addChildViewControllers() {
        
//        setChildViewController(CDHomeViewController(), title: "首页", imageName: "button_list")
//        setChildViewController(CDChannelViewController(), title: "咨询", imageName: "button_list")
//        setChildViewController(CDProfileViewController(), title: "我的", imageName: "button_profile")
        
    }
    
    private func setChildViewController(_ childController : UIViewController, title : String, imageName : String) {
        
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName + "_nor")
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_select")
        addChildViewController(CDNavigationController(rootViewController: childController))
        
    }
    
    
}
