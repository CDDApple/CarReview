//
//  CRMenuList.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/11.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CRMenuList: NSObject, NSCoding {
    var name : String
    var uid : String
    
    required init?(name : String = "", uid : String = "") {
        self.name = name
        self.uid = uid
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey:"name")
        aCoder.encode(uid, forKey:"uid")
    }
}
