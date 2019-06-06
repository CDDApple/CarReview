//
//  CRMenuEditViewController.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/11.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CRMenuEditViewController: CDBaseViewController {

    var editBlock : ((_ model : CRHomeContentModel)->())?
    
    private var viewModel: CRMenuEditViewModel!
    let disposeBag = DisposeBag()
    
    lazy var contentView = CRMenuEditView().then({
        $0.backgroundColor = UIColor.black
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "添加频道"
        let rightItem = UIBarButtonItem(title: "保存", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightItem
        
        rightItem.rx.tap
            .bind { [weak self] in
                self?.navigationSave()
        }.disposed(by: disposeBag)
        
        viewModel = CRMenuEditViewModel(
            name: contentView.nameText.rx.text.orEmpty.asObservable(),
            uid: contentView.uidText.rx.text.orEmpty.asObservable()
        )
        viewModel.everythingValid
            .bind(to: rightItem.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    
    override func configUI() {
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    @objc private func navigationSave() {
        
        if !check() { return }
        
        var model = CRHomeContentModel()
        model.name = contentView.nameText.text ?? "" //"警告车主"
        model.uid =  contentView.uidText.text ?? "" //"UMTgzODUxNzgzNg"
        self.editBlock?(model)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func check() -> Bool {
        
        if contentView.nameText.text?.count ?? 0 > 6 {
            UNoticeBar(config: UNoticeBarConfig(title: "名称不超过6个字")).show(duration: 1.2)
            return false
        }
        return true
    }
    
}
