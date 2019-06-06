//
//  CDBaseCollectionViewCell.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/24.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit
import Reusable

class CDBaseCollectionViewCell: UICollectionViewCell, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}
}
