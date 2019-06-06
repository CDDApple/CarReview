//
//  CDBaseTableViewCell.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/8.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit
import Reusable

class CDBaseTableViewCell: UITableViewCell, Reusable {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}

}
