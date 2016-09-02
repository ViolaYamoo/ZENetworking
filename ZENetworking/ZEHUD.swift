//
//  ZEHUD.swift
//  ZENetworking
//
//  Created by zhangll on 16/9/1.
//  Copyright © 2016年 zhangll. All rights reserved.
//

import UIKit
import MBProgressHUD

let showView = ((UIApplication.sharedApplication().delegate?.window)!)! as UIView

class ZEHUD: NSObject {

    /**
     * 显示错误信息
     */
    class func showError(error:String) {
        self.showCustomIcon("error.png", title: error)
    }
    ///显示成功信息
    class func showSuccess(success:String) {
        
        self.showCustomIcon("success.png", title: success)
    }
    ///显示一个提示信息
    class func showMessage(message:String){
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showHUDAddedTo(showView, animated: true)
        hud.label.text = message
    }
    /**
     *  进度条View
     */
    class func showProgressToView(model:MBProgressHUDMode,text:String){
        let hud = MBProgressHUD.showHUDAddedTo(showView, animated: true)
        hud.mode = model
        hud.label.text = text
    }
    ///自动消失提示，无图
    class func showAutoMessage(message:String){
        self.showMessage(message, remainTime: 0.9, mode: .Text)
    }
    ///自定义停留时间，有图
    class func showIconMessage(message:String,remainTime:CGFloat){
        self.showMessage(message, remainTime: remainTime, mode: .Indeterminate)
    }
    ///自定义停留时间，无图
    class func showMessage(message:String,remainTime:CGFloat){
        self.showMessage(message, remainTime: remainTime, mode: .Text)
    }
    ///显示带图片信息
    class func showCustomIcon(iconName:String,title:String){
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showHUDAddedTo(showView, animated: true)
        hud.label.text = title
        
        if (iconName == "error.png") || (iconName == "success.png"){
            hud.customView = UIImageView(image: UIImage(named: "MBProgressHUD.bundle/\(iconName)"))
        }else{
            hud.customView = UIImageView(image: UIImage(named: iconName))
        }
        // 再设置模式
        hud.mode = .CustomView
        // 1秒之后再消失
        hud.hideAnimated(true, afterDelay: 0.9)
        
    }
    ///隐藏HUD
    class func hideHUD(){
        MBProgressHUD.hideHUDForView(showView, animated: true)
    }
    
    
    private class func showMessage(message:String,remainTime:CGFloat,mode:MBProgressHUDMode){
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showHUDAddedTo(showView, animated: true)
        hud.label.text = message
        //模式
        hud.mode = mode
        // X秒之后再消失
        hud.hideAnimated(true, afterDelay: NSTimeInterval(remainTime))
    }

}