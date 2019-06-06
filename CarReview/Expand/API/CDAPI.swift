//
//  CDAPI.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/9.
//  Copyright © 2018年 caodd. All rights reserved.
//

import Moya
import HandyJSON

let DouBanProvider = MoyaProvider<CDApi>()

enum CDApi {
    case TopicList(topicid: String) // 专题详情列表
}

extension CDApi: TargetType {
    var baseURL: URL {
        switch self {
        case .TopicList:
            return URL(string: "http://c-api.youku.com")!
        }
    }
    
    var path: String {
        switch self {
            case .TopicList: return "/collection"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        
        switch self {
        case .TopicList(let topicid):
            let parmeters : [String : Any] = ["clid":topicid]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
        }
        
    }
    var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
