//
//  ZEExtension.swift
//  ZENetworking
//
//  Created by zhangll on 16/9/1.
//  Copyright © 2016年 zhangll. All rights reserved.
//

import UIKit
import Foundation

extension String{
    var md5String:String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!,strLen,result)
        
        let hash = NSMutableString()
        
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        
        return String(format: hash as String)
    }
}
class ZEViewController:UIViewController,ZENoNetViewDelegate{
    func showNonetWork(){
        let view = ZENoNetView.instanceNoNetView()
        view.delegate = self
        self.view.addSubview(view)
    }
    
    func hiddenNonetWork(){
        for view in self.view.subviews {
            if view.isKindOfClass(ZENoNetView.self) {
                view.removeFromSuperview()
            }
        }
    }
    func reloadNetworkDataSource(){
        //刷新数据
    }
}