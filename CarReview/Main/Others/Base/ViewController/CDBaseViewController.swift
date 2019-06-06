//
//  CDBaseViewController.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/7.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit

class CDBaseViewController: UIViewController {
    
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.delegate = self;
        
        view.backgroundColor = UIColor.backgroudColor
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.delegate = self;
    }
    
    func configUI() {}

    // 是否隐藏导航条
    func needHiddenNavBar() -> Bool {
        return false
    }
    
    func changeStateBarStyle() -> UIStatusBarStyle {
        return .default
    }
    
    func animationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?  {
        return nil
    }
    
}

extension CDBaseViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(needHiddenNavBar(), animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
    
}
