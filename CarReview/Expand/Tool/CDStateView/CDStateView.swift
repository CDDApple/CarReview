//
//  CDStateView.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/28.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit

enum ViewStyle : Int{
    case none
    case loading
    case empty
    case error
    case neterror
}

class CDStateView: UIView {

    var addTapBlock : (()->Void)?
    
    private lazy var loadingView : CDLoadingView = {
        let lv = CDLoadingView()
        lv.backgroundColor = UIColor.backgroudColor
        self.addSubview(lv)
        lv.snp.makeConstraints {
            $0.edges.equalTo(self.usnp.edges)
        }
        return lv
    }()
    
    private lazy var emptyView : CDEmptyView = {
        let ev = CDEmptyView()
        ev.backgroundColor = UIColor.backgroudColor
        self.addSubview(ev)
        ev.snp.makeConstraints {
            $0.edges.equalTo(self.usnp.edges)
        }
        return ev
    }()
    
    private lazy var errorView : CDErrorView = {
        let ev = CDErrorView()
        ev.backgroundColor = UIColor.backgroudColor
        ev.actionBtnBlock { [weak self] in
            self?.addTapBlock?()
            self?.viewStyle = .loading
        }
        self.addSubview(ev)
        ev.snp.makeConstraints {
            $0.edges.equalTo(self.usnp.edges)
        }
        return ev
    }()
    
    private lazy var neterrorView : CDNetErrorView = {
        let ev = CDNetErrorView()
        ev.backgroundColor = UIColor.backgroudColor
        ev.actionBtnBlock { [weak self] in
            self?.addTapBlock?()
            self?.viewStyle = .loading
        }
        self.addSubview(ev)
        ev.snp.makeConstraints {
            $0.edges.equalTo(self.usnp.edges)
        }
        return ev
    }()
    
    public var viewStyle : ViewStyle = .none {
        didSet{
            self.isHidden = false
            switch viewStyle {
            case .none:
                print("视图消失")
                
                loadingView.stopAnimation()
                
                self.isHidden = true
                loadingView.isHidden = true
                emptyView.isHidden = true
                errorView.isHidden = true
                neterrorView.isHidden = true
                
            case .loading:
                print("加载中")
                loadingView.startAnimation()
                
                loadingView.isHidden = false
                emptyView.isHidden = true
                errorView.isHidden = true
                neterrorView.isHidden = true
            case .empty:
                print("空视图")
                emptyView.show()
                loadingView.stopAnimation()
                
                loadingView.isHidden = true
                emptyView.isHidden = false
                errorView.isHidden = true
                neterrorView.isHidden = true
            case .error:
                print("错误视图")
                errorView.show()
                
                loadingView.stopAnimation()
                
                loadingView.isHidden = true
                emptyView.isHidden = true
                errorView.isHidden = false
                neterrorView.isHidden = true
            case .neterror:
                print("网络错误视图")
                neterrorView.show()
                
                loadingView.stopAnimation()
                
                loadingView.isHidden = true
                emptyView.isHidden = true
                errorView.isHidden = true
                neterrorView.isHidden = false
            }
        }
    }

}
