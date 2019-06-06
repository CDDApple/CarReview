//
//  CRHomeListViewController.swift
//  CarReview
//
//  Created by 曹冬冬 on 2019/3/5.
//  Copyright © 2019 CarReview. All rights reserved.
//

import UIKit
import JXSegmentedView
import Then
import TFHpple

class CRHomeListViewController: CDBaseViewController {

    var didSelectedCell : ((_ model: CRContentModel, _ homeModel: CRHomeModel, _ cell: CRHomeNewListCell)->())?
    
    private var videoList = [CRContentModel]()
    var homeModel = CRHomeModel()
    var contentModel : CRHomeContentModel?
    
    private lazy var stateView : CDStateView = {
        let sv = CDStateView()
        sv.viewStyle = .loading
        sv.addTapBlock = { [weak self] in
            self?.loadData(true)
        }
        return sv
    }()
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.backgroudColor
        tw.delegate = self
        tw.dataSource = self
        tw.estimatedRowHeight = 200
        tw.rowHeight = UITableViewAutomaticDimension
        tw.separatorStyle = .none
        tw.register(cellType: CRHomeNewListCell.self)
        tw.cHead = CDRefreshHeader { [weak self] in self?.loadData(true) }
        tw.cFoot = CDRefreshFooter { [weak self] in self?.loadData(false) }
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(true)
    }
    
    override func configUI() {
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(stateView)
        stateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadData(_ isHeaderFresh :Bool) {
        
        guard let model = self.contentModel else {return}
        
        let videoeUrl = "http://i.youku.com/i/\(model.uid)==/videos"
        var url = videoeUrl
        
        if(isHeaderFresh){
            
            self.videoList.removeAll()
            
            self.pageIndex = 1
            url = videoeUrl
        }else{
            self.pageIndex += 1
            url = videoeUrl + "?page=\(self.pageIndex)"
        }
        
        self.homeModel.contentModel = model
        DispatchQueue.global().async {
            guard let url = URL(string: url) else{
                DispatchQueue.main.async {
                    self.stateView.viewStyle = .error
                }
                return
            }
            guard let data = NSData(contentsOf: url) else {
                DispatchQueue.main.async {
                    self.stateView.viewStyle = .error
                }
                return
            }
            
            let xpathParser = TFHpple(htmlData: data as Data?)
            let dataArr = xpathParser?.search(withXPathQuery: "//a")
            
            for element in dataArr! {
                
                var model = CRContentModel()
                
                let elements = element as! TFHppleElement
                let str = elements.object(forKey: "class")
                
                if str == "head-box" {
                    if let fheadigure = elements.firstChild.firstChild.attributes["src"] {
                        let headfigure = "\(fheadigure)"
                        self.homeModel.headfigure =  headfigure.hasPrefix("http") ? headfigure : "http:\(headfigure)"
                    }else{
                        if let fheadigure = elements.firstChild.firstChild.firstChild.attributes["src"] {
                            let headfigure = "\(fheadigure)"
                            self.homeModel.headfigure =  headfigure.hasPrefix("http") ? headfigure : "http:\(headfigure)"
                        }
                    }
                }else if str == "head-avatar" {
                    if let avatar = elements.firstChild.firstChild.attributes["src"] {
                        self.homeModel.avatar = avatar as! String
                    }
                }else if str == "user-name" {
                    if let name = elements.firstChild.content {
                        self.homeModel.name = name
                    }
                }else if str == "user-desc" {
                    if let desc = elements.content {
                        let descTemp = desc.replacingOccurrences(of: "简介:", with: "")
                        self.homeModel.desc = descTemp
                    }
                }else if str == "user-state" {
                    if let userstate = elements.content {
                        let array = userstate.components(separatedBy:"视频播放数")
                        
                        if let viewNum = array.first {
                            self.homeModel.viewNum = viewNum
                        }
                        if let playNum = array.last {
                            
                            let num = playNum.replacingOccurrences(of: "粉丝数", with: "")
                            self.homeModel.fansNum = num
                        }
                        
                    }
                }
                
                
                if str == "v va" {
                    if let nameList = elements.firstChild.firstChild.attributes["alt"] {
                        if nameList as! String == "暂无截图" { continue }
                        model.videoTitle = nameList as! String
                    }
                    
                    if let imageurl = elements.firstChild.firstChild.attributes["src"] {
                        model.videoCover = imageurl as! String
                    }
                    
                    let link_childrenArr = elements.children(withClassName: "v-link")
                    let linkNode = link_childrenArr?.first as! TFHppleElement
                    
                    if let href = linkNode.firstChild.attributes["href"]{
                        let url = "http://139.129.237.236:12135/single/i.php?ctype=phone&hd=3&token=23e38f17117394d37302bc58d00019ae&url=http:\(href)"
                        model.videoeUrl = url
                    }
                    
                    if linkNode.children.count > 2 {
                        let time = linkNode.children![2] as! TFHppleElement
                        
                        if let videoTime = time.firstChild.firstChild.content {
                            model.videoLongTime = videoTime
                        }
                    }
                    
                    let meta_childrenArr = elements.children(withClassName: "v-meta")
                    let metaNode = meta_childrenArr?.first as! TFHppleElement
                    
                    if let href = metaNode.firstChild.attributes["href"]{
                        let url = "http://139.129.237.236:12135/single/i.php?ctype=phone&hd=3&token=23e38f17117394d37302bc58d00019ae&url=http:\(href)"
                        model.videoeUrl = url
                    }
                    
                    let metaPlayNumNode = meta_childrenArr?.last as! TFHppleElement
                    let metaEntry = metaPlayNumNode.children.last as! TFHppleElement
                    let playNum = metaEntry.children.last as! TFHppleElement
                    model.videoPlayNum = playNum.content
                    let addtime = metaEntry.children.first as! TFHppleElement
                    model.videoTime = addtime.content
                    self.videoList.append(model)
                }
            }
            
            DispatchQueue.main.async {
                self.stateView.viewStyle = self.videoList.count > 0 ? .none : .error
                self.tableView.cFoot.endRefreshing()
                self.tableView.cHead.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

}

extension CRHomeListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CRHomeNewListCell.self)
        cell.model = self.videoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.videoList[indexPath.row]
        let cell = (tableView.cellForRow(at: indexPath) as! CRHomeNewListCell)
        self.didSelectedCell?(model, homeModel, cell)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

extension CRHomeListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
