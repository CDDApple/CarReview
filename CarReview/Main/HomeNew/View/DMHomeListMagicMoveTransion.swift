//
//  DMHomeListMagicMoveTransion.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/8.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class DMHomeListMagicMoveTransion: NSObject , UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1.获取动画的源控制器和目标控制器
        let fromVC = transitionContext.viewController(forKey: .from) as! CRHomeNewViewController
        let toVC = transitionContext.viewController(forKey: .to) as! CRHomeDetailViewController
        let container = transitionContext.containerView
        
        let currentView = fromVC.selectedCell
//        currentView!.isHidden = true
        
        let snapshotCoverView = currentView!.coverImage.snapshotView(afterScreenUpdates: false)
        snapshotCoverView!.frame = container.convert((currentView!.coverImage.frame), from: currentView!.bgView)
        currentView!.coverImage.isHidden = true

        let snapshotPlayView = currentView!.playImage.snapshotView(afterScreenUpdates: false)
        snapshotPlayView!.frame = container.convert((currentView!.playImage.frame), from: currentView!.bgView)
        currentView!.playImage.isHidden = true
        
        
        //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toVC.playView.isHidden = true
        
        //4.都添加到 container 中。注意顺序不能错了
        container.addSubview(toVC.view)
        container.addSubview(snapshotCoverView!)
        container.addSubview(snapshotPlayView!)
        
        toVC.view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            let H = (screenWidth * 9) / 16
            snapshotCoverView!.frame = CGRect(x: 0, y: navbarHeight, width: screenWidth, height: H)
            let palyWH = CGFloat(60)
            snapshotPlayView!.frame = CGRect(x: (screenWidth - palyWH) / 2, y: (H - palyWH) / 2 + navbarHeight, width: palyWH, height: palyWH)
            
            toVC.view.alpha = 1
        }, completion: { _ in
            toVC.playView.isHidden = false
            
            currentView!.isHidden = false
            currentView!.coverImage.isHidden = false
            currentView!.playImage.isHidden = false
            
            snapshotCoverView!.isHidden = true
            snapshotCoverView!.removeFromSuperview()
            
            snapshotPlayView!.isHidden = true
            snapshotPlayView!.removeFromSuperview()
            //一定要记得动画完成后执行此方法，让系统管理 navigation
            transitionContext.completeTransition(true)
        })
    }
    
}

