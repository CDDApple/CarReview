//
//  CRMenuViewController.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/5.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit

class CRMenuViewController: CDBaseViewController {

    var sectionsBlock : ((_ sections : [CRHomeContentModel])->())?
    var sections :  [CRHomeContentModel]?
    var isEdit :  Bool = false
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.backgroudColor
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.isEditing = true
        tw.register(cellType: CRHomeMenuCell.self)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "频道管理"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(navigationBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(navigationAdd))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 禁用手势返回
        if let nav = self.navigationController as? CDNavigationController {
            nav.disableFullScreenPop = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 禁用手势返回
        if let nav = self.navigationController as? CDNavigationController {
            nav.disableFullScreenPop = false
        }
    }
    
    override func configUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.usnp.edges)
        }
        
    }
    
    @objc private func navigationBack() {
        if isEdit {
            self.sectionsBlock?(sections ?? [])
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func navigationAdd() {
        let vc = CRMenuEditViewController()
        vc.editBlock = { [weak self] (model) in
            self?.sections?.append(model)
            self?.isEdit = true
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension CRMenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    // 设置tableView每个部分Header内容
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = UIColor.black
        let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width, height: 60))
        viewLabel.text = "自己个儿"
        viewLabel.font = UIFont(name: "PingFangSC-Semibold", size: 40)
        viewLabel.textColor = UIColor.primaryColor()
        view.addSubview(viewLabel)
        tableView.addSubview(view)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CRHomeMenuCell.self)
        if self.sections?.count ?? 0 > 0 {
            cell.model = sections![indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("\(sourceIndexPath.row)------\(destinationIndexPath.row)" )
        if let model = sections?[sourceIndexPath.row] {
            sections?.remove(at: sourceIndexPath.row)
            sections?.insert(model, at: destinationIndexPath.row)
            isEdit = true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row < sections?.count ?? 0 {
                sections?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                self.isEdit = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    
}
