//
//  CDNavigationController.swift
//  SwiftBP
//
//  Created by caodd on 2018/7/23.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit

class CDNavigationController: UINavigationController {

    // 禁用手势返回 默认:false 
    var disableFullScreenPop : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(named: "navBgImage"), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        addFullScreenPopGestureAction()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disableFullScreenPop = false
    }
    
    // 拦截 push 操作
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(navigationBack))
        }
        
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    /// 返回上一控制器
    @objc private func navigationBack() {
        popViewController(animated: true)
    }
    
    func addFullScreenPopGestureAction() {
        
        // 获取系统的Pop手势
        guard let systemGes = interactivePopGestureRecognizer else { return }
        // 获取系统手势添加的view
        guard let gesView = systemGes.view else { return }
        //从Targets 取出 Target
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        guard let target = targetObjc.value(forKey: "target") else { return }
        //方法名称获取 Action
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer()
        panGes.maximumNumberOfTouches = 1
        panGes.delegate = self;
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
        
    }
    
}


extension CDNavigationController : UIGestureRecognizerDelegate {
    
    //
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if(disableFullScreenPop) {return false}
        
        let translation = gestureRecognizer.location(in: gestureRecognizer.view);
        if translation.x <= 0 {return false}
        
        if self.viewControllers.count <= 1 {return false}
        
        return true
    }
}
