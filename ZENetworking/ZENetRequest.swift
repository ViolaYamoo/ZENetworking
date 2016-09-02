//
//  ZENetRequest.swift
//  ZENetworking
//
//  Created by zhangll on 16/8/31.
//  Copyright © 2016年 zhangll. All rights reserved.
//

import UIKit

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typealias ZENetRequestSuccessClose = (AnyObject?) -> Void

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typealias ZENetRequestFailureClose = (NSError?) -> Void

class ZENetRequest: NSObject {

    class func getList(params:[String : AnyObject],successClose:ZENetRequestSuccessClose,failureClose:ZENetRequestFailureClose){
        
        var cachePolicy:ZEHTTPRequestCachePolicy = .ReturnCacheDataThenLoad
        if !ZENetworkManager.checkConnect() {
            cachePolicy = .ReturnCacheDataDontLoad
        }
        
        let url = API_CONNET + API_COURSE_CHOICE

        ZENetworkManager.sharedInstance.request(url, netType: .GET, params: params, cachePolicy: cachePolicy, successBlock: { (object) in
            if let anyObject = object?.object as? NSDictionary{
                let array = anyObject.objectForKey("data") as! NSArray
                let returnArray = NSMutableArray()
                for dic in array{
                    returnArray.addObject(dic.objectForKey("name")!)
                }
                successClose(returnArray)
            }
            }, failureBlock: { (error) in
                print(error)
                failureClose(error)
        })
    }
}
