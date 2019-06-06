//
//  CDBaseView.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/5.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CDBaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    open func configUI() {
        
    }

}
