//
//  ZENetworkItem.swift
//  ZENetworking
//
//  Created by zhangll on 16/8/31.
//  Copyright © 2016年 zhangll. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ZENetworkItem: NSObject {

    var request:Request?
    func requestWithType(netType:ZENetworkType,
                         URLString:String,
                         params:[String:AnyObject],
                         successBlock:ZENetworkSuccessBlock?,
                         failureBlock:ZENetworkFailureBlock?){
        ZEHUD.showMessage("加载中...")
        switch netType {
        case .GET:
            request = Alamofire.request(.GET, URLString, parameters: params).responseJSON(completionHandler: { (response:Response) in
                ZEHUD.hideHUD()
                guard response.result.isSuccess else {
                    print("error")
                    failureBlock?(response.result.error)
                    return
                }
                
                if let value = response.result.value{
                    let dict = JSON(value)
                    successBlock?(dict)
                }
            })
        case .POST:
            request = Alamofire.request(.POST, URLString, parameters: params).responseJSON(completionHandler: { (response:Response) in
                ZEHUD.hideHUD()
                guard response.result.isSuccess else {
                    print("error")
                    failureBlock?(response.result.error)
                    return
                }
                
                if let value = response.result.value{
                    let dict = JSON(value)
                    successBlock?(dict)
                }
            })
        case .DELETE:
            request = Alamofire.request(.DELETE, URLString, parameters: params).responseJSON(completionHandler: { (response:Response) in
                ZEHUD.hideHUD()
                guard response.result.isSuccess else {
                    print("error")
                    failureBlock?(response.result.error)
                    return
                }
                
                if let value = response.result.value{
                    let dict = JSON(value)
                    successBlock?(dict)
                }
            })
        }
    }
    func cancleRequest(){
        request?.cancel()
    }
}
/**
 *  请求类型
 */
enum ZENetworkType:Int {
    case GET, POST, DELETE
}
/**
 *  网络状态
 */
enum ReachabilityType: CustomStringConvertible {
    case WWAN
    case WiFi
    
    var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}
enum ReachabilityStatus: CustomStringConvertible  {
    case Offline
    case Online(ReachabilityType)
    case Unknown
    
    var description: String {
        switch self {
        case .Offline: return "Offline"
        case .Online(let type): return "Online (\(type))"
        case .Unknown: return "Unknown"
        }
    }
}
/**
 *  网络请求超时的时间
 */
let ZE_API_TIME_OUT = 20

//关于网络检测枚举
let ReachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"


//-----创建闭包（OC中的block）
/**
 *  请求开始的回调（下载时用到）
 */
typealias ZENetworkStartBlock  = () -> Void

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typealias ZENetworkSuccessBlock = (JSON?) -> Void

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typealias ZENetworkFailureBlock = (NSError?) -> Void

/**
 *  上传文件的block
 */
typealias ZENetworkUploadClosureBlock = (AnyObject?, NSError?,Int64?,Int64?,Int64?)->Void
