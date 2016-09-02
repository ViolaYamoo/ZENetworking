//
//  ZENetworkManager.swift
//  ZENetworking
//
//  Created by zhangll on 16/8/31.
//  Copyright © 2016年 zhangll. All rights reserved.
//

import UIKit
import SystemConfiguration
import YYCache
import SwiftyJSON

enum ZEHTTPRequestCachePolicy {
    ///< 有缓存就先返回缓存，同步请求数据
    case ReturnCacheDataThenLoad
    ///< 忽略缓存，重新请求
    case ReloadIgnoringLocalCacheData
    ///< 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    case PReturnCacheDataElseLoad
    ///< 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
    case ReturnCacheDataDontLoad
}

let ZEHTTPRequestCache = "ZEHTTPRequestCache"
class ZENetworkManager: NSObject {

    //单例模式
    static let sharedInstance = ZENetworkManager()
    
    /**
     * 网络请求总的 items
     */
    var items = [ZENetworkItem]()
    /**
     *   单个网络请求项
     */
    var netWorkItem: ZENetworkItem?
    
    /**
     *  networkError
     */
    let networkError = Bool()

    
    func request(url:String,
                 netType:ZENetworkType,
                 params:[String:AnyObject]?,
                 cachePolicy:ZEHTTPRequestCachePolicy,
                 successBlock:ZENetworkSuccessBlock?,
                 failureBlock:ZENetworkFailureBlock?) -> ZENetworkItem?{
        if networkError {
            if failureBlock != nil {
                failureBlock!(nil)
            }
            return nil
        }
        var cacheKey = url
        do{
            let data = try NSJSONSerialization.dataWithJSONObject(params!, options: .PrettyPrinted)
            let str = String(data: data, encoding: NSUTF8StringEncoding)
            
            cacheKey = url.stringByAppendingString(str!).md5String
            //缓存
        }catch{
            cacheKey = url.md5String
            ZEHUD.showError("缓存键值错误")
        }
        let cache = YYCache(name: ZEHTTPRequestCache)
        cache?.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = true
        cache?.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = true
        //拿缓存，先返回缓存
        var object:JSON?
        if let obj = cache?.objectForKey(cacheKey) as? NSData{
            object = JSON(data: obj)
        }
        
        switch cachePolicy {
        case .ReturnCacheDataThenLoad://先返回缓存，同时请求
            if (object != nil) {
                successBlock?(object)
            }
            break
        case .ReloadIgnoringLocalCacheData://忽略本地缓存直接请求
            //不做处理，直接请求
            break
        case .PReturnCacheDataElseLoad://有缓存就返回缓存，没有就请求
            if (object != nil) {
                successBlock?(object)
                return nil
            }
        case .ReturnCacheDataDontLoad://有缓存就返回缓存,从不请求（用于没有网络）
            if (object != nil) {
                successBlock?(object)
            }
            return nil //退出从不请求
        }
        //发送请求
        netWorkItem = ZENetworkItem()
        netWorkItem?.requestWithType(netType, URLString: url, params: params!, successBlock: { (json) in
            //缓存数据
            do {
                let data = try json?.rawData()
                cache?.setObject(data, forKey: cacheKey)
            }catch{
                ZEHUD.showError("缓存内容出错")
            }
            //返回请求数据
            successBlock?(json)
            }, failureBlock: { (error) in
                failureBlock?(error)
        })
        items.append(netWorkItem!)
        return netWorkItem!
    }
    /**
     *   取消所有正在执行的网络请求项
     */
    class func cancleAllNetItems() {
        let manager = ZENetworkManager.sharedInstance
        for item in manager.items {
            item.cancleRequest()
        }
        manager.items.removeAll()
        manager.netWorkItem = nil
    }
    
    /**
     *  //检测网络 监听网络状态的变化
     */
    class func checkConnect() -> Bool {
        let status = ZENetworkManager.connectionStatus()
        switch status {
        case .Unknown,.Offline:
            return false
        case .Online(.WWAN):
            return true
        case .Online(.WiFi):
            return true
        }
    }
    //网络检测的方法
    class func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return .Unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .Unknown
        }
        return ReachabilityStatus(reachabilityFlags: flags)

    }
    
}
extension ReachabilityStatus{
    private init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.ConnectionRequired)
        let isReachable = flags.contains(.Reachable)
        let isWWAN = flags.contains(.IsWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .Online(.WWAN)
            } else {
                self = .Online(.WiFi)
            }
        } else {
            self =  .Offline
        }
    }
    
}
