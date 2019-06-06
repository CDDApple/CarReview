//
//  CDNetErrorView.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/29.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit

class CDNetErrorView: CDEmptyBaseView {

    override func show() {
        
        iconImageName = "signal_wifi_off"
        titleStr = "网络出错了"
        descStr = "网络出错了,请点击按钮重新加载~"
    }
}
