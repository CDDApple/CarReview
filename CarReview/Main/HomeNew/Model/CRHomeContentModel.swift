//
//  CRHomeContentModel.swift
//  CarReview
//
//  Created by caodd on 2018/9/8.
//  Copyright © 2018年 CarReview. All rights reserved.
//

import UIKit

import HandyJSON

struct CRHomeContentModel: HandyJSON {
    var name: String = ""
    var uid: String = ""
}

struct CRHomeModel: HandyJSON {
    var headfigure: String = ""
    var avatar: String = ""
    var name: String = ""
    var desc: String = ""
    var viewNum: String = ""
    var fansNum: String = ""
    var contentModel: CRHomeContentModel?
}

struct CRContentModel: HandyJSON {
    var videoCover: String = ""
    var videoTitle: String = ""
    var videoeUrl: String = ""
    var videoLongTime: String = ""
    var videoTime: String = ""
    var videoPlayNum: String = ""
}


struct CRTopicListModel: HandyJSON {
    var topicid: String = ""
    var coverImage: String = ""
    var title: String = ""
    var videoNum: String = ""
    var playNum: String = ""
}

struct CRTopicModel: HandyJSON {
    var code: String = ""
    var ok: String = ""
    var result: CRTopicResultModel?
}

struct CRTopicResultModel: HandyJSON {
    var videos: CRTopicVideoModel?
}


struct CRTopicVideoModel: HandyJSON {
    var data: [CRTopicDataModel]?
}

struct CRTopicDataModel: HandyJSON {
    var fmt_view_count: String = ""
    var fmt_duration: String = ""
    var title: String = ""
    var thumbnail: String = ""
    var `id`: String = ""
}
