//
//  CDRefresh.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/29.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {

    var cHead: MJRefreshHeader {
        get { return mj_header }
        set { mj_header = newValue }
    }
    
    var cFoot: MJRefreshFooter {
        get { return mj_footer }
        set { mj_footer = newValue }
    }
    
}

class CDRefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
//        setImages([UIImage(named: "refresh_normal")!], for: .idle)
//        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
//        setImages([UIImage(named: "refresh_loading_1")!,
//                   UIImage(named: "refresh_loading_2")!,
//                   UIImage(named: "refresh_loading_3")!], for: .refreshing)
        
//        lastUpdatedTimeLabel.isHidden = true
//        stateLabel.isHidden = true
    }
}

class CDRefreshFooter: MJRefreshAutoNormalFooter {
    
    override func prepare() {
        super.prepare()
        
        setTitle("正在加载...", for: .refreshing)
        setTitle("全部加载完毕", for: .noMoreData)
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        
    }
}
