//
//  CDEmptyView.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/28.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit

class CDEmptyView: CDEmptyBaseView {
    
    override func show() {
    
        isHideActionBtn = true
        
        iconImageName = "empty"
        titleStr = "无数据"
        
    }
}
