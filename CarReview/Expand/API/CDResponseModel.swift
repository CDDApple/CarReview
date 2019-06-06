//
//  CDResponseModel.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/24.
//  Copyright © 2018年 caodd. All rights reserved.
//

import HandyJSON

class CDResponseModel: HandyJSON {
    
    var success: Bool = false
    var errorCode: String?
    var message: String?
    var timestamp: String?
    var single: String?
    var list: String?
    var pageModel: String?
    var `extension`: String?
    var `id`: String?
    
    required init() {}
}


enum ResponseCode: Int, HandyJSONEnum {
    case success = 200
    case fail = -1
    case logout = 10504
}


enum APIError: Error {
    // 请求出错,服务器返回对应的描述文字
    case error(wrong: String)
    // 服务器返回的数据不是JSON
    case dataJSON(wrong: String)
    // 服务器返回的数据为空
    case dataEmpty(wrong: String)
    // 服务器返回的数据不能解析
    case datamatch(wrong: String)
    // 网络请求错误
    case network(wrong: String)
    
    static func networkWrong(with error: NSError) -> APIError {
        if let errorMessage = error.userInfo["NSLocalizedDescription"] as? String {
            return APIError.network(wrong: errorMessage)
        }
        
        if error.domain == "Alamofire.AFError" {
            if error.code == 4 {
                return APIError.dataEmpty(wrong: "Server return data is nil or zero length.")
            }
        }
        return APIError.network(wrong: "Unknown Network Wrong.")
    }
}

extension APIError {
    func showHUD() {
        switch self {
        case .error(let wrong):
            print(wrong)
            break
        case .dataEmpty(let wrong):
            print(wrong)
            break
        case .dataJSON(let wrong):
            print(wrong)
            break
        case .datamatch(let wrong):
            print(wrong)
            break
        case .network(let wrong):
            print(wrong)
            break
        }
    }
}
