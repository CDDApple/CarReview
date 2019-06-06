//
//  CRMenuEditViewModel.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/13.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit
import RxSwift

class CRMenuEditViewModel: NSObject {
    // 输入
    let nameVaild : Observable<Bool>
    let uidVaild : Observable<Bool>
    let everythingValid: Observable<Bool>
    
    init(name:Observable<String>, uid:Observable<String>) {
        
        nameVaild = name
            .map { $0.count >= 1 }
            .share(replay: 1, scope: .forever)
        uidVaild = uid
            .map { $0.count >= 1 }
            .share(replay: 1, scope: .forever)
        
        everythingValid = Observable.combineLatest(nameVaild, uidVaild) { $0 && $1 }
            .share(replay: 1, scope: .forever)
    }
}
