//
//  CDErrorView.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/29.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit

class CDErrorView: CDEmptyBaseView {
    
    override func show() {
        
        iconImageName = "pop-failure"
        titleStr = ""
        descStr = "请求失败,请点击按钮重新加载~"
    }
    
}
