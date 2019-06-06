//
//  CDNetworkManager.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/22.
//  Copyright © 2018年 caodd. All rights reserved.
//

import Foundation
import Moya
import HandyJSON
import Alamofire
import RxSwift

/// 超时时长
private var requestTimeOut:Double = 30
/// 成功数据的回调
typealias successCallback = ((CRTopicModel) -> (Void))
/// 失败的回调
typealias failedCallback = ((MoyaError) -> (Void))
/// 网络错误的回调
typealias errorCallback = ((Int) -> (Void))


///endpointClosure
private let myEndpointClosure = { (target: CDApi) -> Endpoint in
    ///这里的endpointClosure和网上其他实现有些不太一样。
    ///主要是为了解决URL带有？无法请求正确的链接地址的bug
    let url = target.baseURL.absoluteString + target.path
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = 30
    return endpoint
}

private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}


/// NetworkActivityPlugin插件用来监听网络请求
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch(changeType){
    case .began:
        print("开始请求网络")
    case .ended:
        print("结束")
    }
}

let ApiProvider = MoyaProvider<CDApi>(requestClosure: requestClosure)
let ApiNetworkProvider = MoyaProvider<CDApi>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 请求成功的回调
func NetWorkRequest(_ target: CDApi, completion: @escaping successCallback ){
    NetWorkRequest(target, completion: completion, failed: nil, errorResult: nil)
}


/// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功的回调
///   - failed: 请求失败的回调
func NetWorkRequest(_ target: CDApi, completion: @escaping successCallback , failed:failedCallback?) {
    NetWorkRequest(target, completion: completion, failed: failed, errorResult: nil)
}


///  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功
///   - failed: 失败
///   - error: 错误
func NetWorkRequest(_ target: CDApi, completion: @escaping successCallback , failed:failedCallback?, errorResult:errorCallback?) {
    //先判断网络是否有链接 没有的话直接返回--代码略
    if !isNetworkConnect{
        print("提示用户网络似乎出现了问题")
        return
    }
    ApiNetworkProvider.request(target) { (result) in
        // 1.成功、失败响应的判断
        switch result {
        case let .success(response):
            do {
                // 2.过滤成功的状态码响应
                _ = try response.filterSuccessfulStatusCodes() // 返回状态码为 200 - 299 的响应
                let returnData = String(data: response.data, encoding: String.Encoding.utf8)!
                if let object = CRTopicModel.deserialize(from: returnData) {
                    completion(object)
                }else{
                    // 数据有误
                }
            }
            catch let error {
                //如果数据获取失败，则返回错误状态码
                if errorResult != nil {
                    errorResult!((error as! MoyaError).response!.statusCode)
                }
            }
                
        case let .failure(error):
            //网络连接失败，提示用户
            print("网络连接失败")
            if failed != nil {
                failed!(error)
            }
        }
    }
}

/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}
 
