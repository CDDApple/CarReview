//
//  Const.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/8.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit

/// 屏幕的宽度
let screenWidth = UIScreen.main.bounds.width
/// 屏幕的高度
let screenHeight = UIScreen.main.bounds.height
//  navbar高度
let navbarHeight : CGFloat = UIDevice.current.isiPhoneX() ? 88.0 : 64.0
//  status高度
let statusHeight: CGFloat = UIDevice.current.isiPhoneX() ? 44: 20
//  tabbar高度
let tabbarHeight : CGFloat = UIDevice.current.isiPhoneX() ? 83.0 : 49.0
