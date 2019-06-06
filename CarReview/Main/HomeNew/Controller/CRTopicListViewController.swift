//
//  CRTopicListViewController.swift
//  CarReview
//
//  Created by caodd on 2018/9/10.
//  Copyright © 2018年 CarReview. All rights reserved.
//

import UIKit
import AVKit

class CRTopicListViewController: CDBaseViewController {

    var model : CRTopicListModel?
    
    private var videoList = [CRTopicDataModel]()
    
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
    
    private lazy var stateView : CDStateView = {
        let sv = CDStateView()
        sv.viewStyle = .loading
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = model?.title
        
        self.loadData(true)
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
        
        guard let model = self.model else {return}
        
    
        NetWorkRequest(CDApi.TopicList(topicid: model.topicid), completion: { result in
            
            self.videoList.removeAll()
            
            if let array = result.result?.videos?.data {
                self.videoList = array
            }
            
            self.stateView.viewStyle = self.videoList.count > 0 ? .none : .empty
            self.tableView.cHead.endRefreshing()
            self.tableView.cFoot.endRefreshing()
            self.tableView.reloadData()

        }, failed: { (error) -> (Void) in
            self.stateView.viewStyle = isHeaderFresh ? .neterror : .none
        }) { (errorCode) -> (Void) in
            self.stateView.viewStyle = isHeaderFresh ? .error : .none
        }
    }
}


extension CRTopicListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CRHomeNewListCell.self)
        cell.topicModel = self.videoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topicModel = self.videoList[indexPath.row]

        let url = "http://139.129.237.236:12135/single/i.php?ctype=phone&hd=3&token=23e38f17117394d37302bc58d00019ae&url=http://v.youku.com/v_show/id_\(topicModel.id).html"

        let playVC = AVPlayerViewController()
        playVC.player = AVPlayer(url: URL(string: url)!)
        playVC.allowsPictureInPicturePlayback = true //这个是允许画中画的
        playVC.player?.play() //这里我设置直接播放,页面弹出后会直接播放,要不然还需要点击一下播放按钮
        self.present(playVC, animated: true, completion: nil)
        
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
