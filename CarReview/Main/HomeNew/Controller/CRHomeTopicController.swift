//
//  CRHomeTopicController.swift
//  CarReview
//
//  Created by caodd on 2018/9/8.
//  Copyright © 2018年 CarReview. All rights reserved.
//

import UIKit
import TFHpple

/// 头部视图的高度
private let headerviewH: CGFloat = 225

class CRHomeTopicController: CDBaseViewController {

    private var topicList = [CRTopicListModel]()
    var homeModel = CRHomeModel()
    
    /// 头部视图图片
    var HeaderImage: UIImageView!
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.backgroudColor
        tw.tableFooterView = UIView()
        tw.contentInset = UIEdgeInsets(top: headerviewH, left: 0, bottom: 0, right: 0)
        tw.contentOffset = CGPoint(x: 0, y: -headerviewH)
        tw.delegate = self
        tw.dataSource = self
        tw.estimatedRowHeight = 200
        tw.rowHeight = UITableViewAutomaticDimension
        tw.separatorStyle = .none
        tw.register(cellType: CRHomeTopicCell.self)
        tw.cHead = CDRefreshHeader { [weak self] in self?.loadData(true) }
        tw.cFoot = CDRefreshFooter { [weak self] in self?.loadData(false) }
        return tw
    }()
    
    
    private lazy var headerView : CRHomeTopicHeaderView = {
        let hv = CRHomeTopicHeaderView()
        hv.frame = CGRect(x: 0, y: 0, width: screenWidth, height: headerviewH)
        hv.backgroundColor = UIColor.black
        hv.backClickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return hv
    }()
    
    private lazy var stateView : CDStateView = {
        let sv = CDStateView()
        sv.viewStyle = .loading
        return sv
    }()
    
    var model : CRHomeModel? {
        didSet {
            guard let model = model else {return}
            headerView.model = model
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData(true)
    }
    
    // 是否隐藏导航条
    override func needHiddenNavBar() -> Bool {
        return true
    }

    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.snp.edges) }
        
        view.addSubview(headerView)
        
        view.addSubview(stateView)
        stateView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    
    private func loadData(_ isHeaderFresh :Bool) {
        
        guard let model = self.model else {return}
        
        guard let contentModel = model.contentModel else {return}
        let playlistsUrl = "http://i.youku.com/i/\(contentModel.uid)==/playlists"
        
        var url = playlistsUrl
        
        if(isHeaderFresh){
            
            self.topicList.removeAll()
            
            self.pageIndex = 1
            url = playlistsUrl
        }else{
            self.pageIndex += 1
            url = playlistsUrl + "?page=\(self.pageIndex)"
        }
        
        DispatchQueue.global().async {
            
            guard let data = NSData(contentsOf: URL(string: url)!) else {
                DispatchQueue.main.async {
                    self.stateView.viewStyle = .error
                }
                return
            }
            
            let xpathParser = TFHpple(htmlData: data as Data?)
            
            let dataArr = xpathParser?.search(withXPathQuery: "//div")
            
            for element in dataArr! {
                
                var model = CRTopicListModel()
                
                let elements = element as! TFHppleElement
                let str = elements.object(forKey: "class")
                
                if str == "item" {
                    if let title = elements.firstChild.firstChild.content {
                        var descTemp = title.replacingOccurrences(of: "视频:", with: ",")
                        descTemp = descTemp.replacingOccurrences(of: "播放:", with: ",")
                        descTemp = descTemp.replacingOccurrences(of: "播放此播单", with: "")
                        
                        let array = descTemp.components(separatedBy:",")
                        if array.count > 0{
                            model.title = array.first!
                        }
                        if array.count > 1{
                            model.videoNum = array[1]
                        }
                        if array.count > 2{
                            model.playNum = array[2]
                        }
                    }
                    
                    if let topicid = elements.firstChild.firstChild.attributes["href"] {
                        let topicid = String.getQueryStringParameter(url: topicid as! String, param: "f")
                        if let topicidTemp = topicid {
                            model.topicid = topicidTemp
                        }
                    }
                    
                    if elements.children.count > 1 {
                        let node = elements.children[1] as! TFHppleElement
                        if let coverImage = node.firstChild.firstChild.attributes["src"] {
                            var image = "\(coverImage)"
                            image = image.replacingOccurrences(of: "0542", with: "0541")
                    
                            model.coverImage = image
                        }
                        if let alt = node.firstChild.firstChild.attributes["alt"] {
                            if alt as! String == "暂无截图" {
                                if elements.children.count > 2 {
                                    let node = elements.children[2] as! TFHppleElement
                                    if let coverImage = node.firstChild.firstChild.attributes["src"] {
                                        var image = "\(coverImage)"
                                        image = image.replacingOccurrences(of: "0542", with: "0541")
                                        
                                        model.coverImage = image
                                    }
                                }
                            }
                        }
                        
                        
                        
                    }
                    
                    self.topicList.append(model)
                }
            }
            
            DispatchQueue.main.async {
                self.stateView.viewStyle = self.topicList.count > 0 ? .none : .empty
                self.tableView.cFoot.endRefreshing()
                self.tableView.reloadData()
            }
            
        }
    }

}

extension CRHomeTopicController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y + scrollView.contentInset.top
        guard offsetY <= 0 else {
            // min函数: 取最小值
            let height = max(headerviewH - offsetY, navbarHeight)
            headerView.frame.size.height = height
            let progress = (headerviewH - height) / (headerviewH - navbarHeight)
            headerView.progress = progress
            return
        }
        headerView.progress = 2
        
        headerView.frame.origin.y = 0

        // 增大 Headerview 高度
        headerView.frame.size.height = headerviewH - offsetY

    }
}

extension CRHomeTopicController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CRHomeTopicCell.self)
        cell.model = self.topicList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CRTopicListViewController()
        vc.model = self.topicList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
