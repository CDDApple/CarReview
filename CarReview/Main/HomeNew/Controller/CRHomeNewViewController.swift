//
//  CRHomeNewViewController.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/5.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit
import JXSegmentedView
import AVKit

class CRHomeNewViewController: CDBaseViewController {
    
    var selectedCell: CRHomeNewListCell!
    /// 存储 plist 文件中的数据
    var dataModel = CRDataModel()
    
    var sections = [CRHomeContentModel]()
    var titles = [String]()
    
    var segmentedDataSource: JXSegmentedBaseDataSource?
    var segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    lazy var menuBtn = UIButton().then({
        $0.setImage(UIImage(named: "menu"), for: .normal)
        $0.addTarget(self, action: #selector(menuBtnClick), for: .touchUpInside)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addListVC()

        
        view.addSubview(menuBtn)
        menuBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(statusHeight)
            $0.right.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
    }
    
    func addListVC() {
        segmentedView.removeFromSuperview()
        listContainerView.removeFromSuperview()
        
        segmentedDataSource = nil
        segmentedView = JXSegmentedView()
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalColor = UIColor.white
        dataSource.titleSelectedColor = .primaryColor()
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 2.0
        dataSource.isTitleStrokeWidthEnabled = true
        dataSource.isSelectedAnimable = true
        dataSource.isItemWidthZoomEnabled = true
        dataSource.titles = titles
        //reloadData(selectedIndex:)一定要调用
        dataSource.reloadData(selectedIndex: 0)
        segmentedDataSource = dataSource
        
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.frame = CGRect(x: 0, y: statusHeight, width: screenWidth - 44, height: 44)
        view.addSubview(segmentedView)
        
        segmentedView.contentScrollView = listContainerView.scrollView
        listContainerView.didAppearPercent = 0.01
        view.addSubview(listContainerView)
        
        listContainerView.reloadData()
    }
    
    /// 设置 UI
    private func setupUI() {
        sections.removeAll()
        titles.removeAll()
        
        dataModel.loadData()
        
        if dataModel.menuList.count == 0 {
            print("没数据")
            // pilst 文件的路径
            let path = Bundle.main.path(forResource: "HomePlist", ofType: "plist")
            // plist 文件中的数据
            let cellPlist = NSArray(contentsOfFile: path!) as! [Any]
            sections = cellPlist.compactMap({ CRHomeContentModel.deserialize(from: $0 as? [String: Any]) })
            
            for model in sections {
                titles.append(model.name)
                dataModel.menuList.append(CRMenuList(name: model.name, uid: model.uid)!)
            }
            dataModel.saveData()
        }else{
            print("有数据")
            
            for model in dataModel.menuList {
                var cmode = CRHomeContentModel()
                cmode.name = model.name
                cmode.uid = model.uid
                sections.append(cmode)
                titles.append(model.name)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        listContainerView.frame = CGRect(x: 0, y: navbarHeight, width: screenWidth, height: view.bounds.size.height - navbarHeight)
    }
    
    override func needHiddenNavBar() -> Bool {
        return true
    }
    
    override func animationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push &&  toVC is CRHomeDetailViewController {
            return DMHomeListMagicMoveTransion()
        } else {
            return nil
        }
    }
    
    @objc func menuBtnClick() {
        let vc = CRMenuViewController()
        vc.sections = sections
        vc.sectionsBlock = { [weak self] (sections) in
            self?.sections.removeAll()
            self?.titles.removeAll()
            self?.dataModel.menuList.removeAll()
            
            for model in sections {
                self?.titles.append(model.name)
                self?.dataModel.menuList.append(CRMenuList(name: model.name, uid: model.uid)!)
            }
            self?.dataModel.saveData()
            
            self?.sections = sections
            
            self?.addListVC()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension CRHomeNewViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}

extension CRHomeNewViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = CRHomeListViewController()
        vc.contentModel = sections[index]
        vc.didSelectedCell = { [weak self] (model, homeModel, cell) in
            self?.selectedCell = cell
            let detalVC = CRHomeDetailViewController()
            detalVC.model = model
            detalVC.homeModel = homeModel
            self?.navigationController?.pushViewController(detalVC, animated: true)
        }
        return vc
    }
}
