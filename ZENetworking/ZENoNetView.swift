//
//  ZENoNetView.swift
//  ZENetworking
//
//  Created by zhangll on 16/9/1.
//  Copyright © 2016年 zhangll. All rights reserved.
//

import UIKit

@objc protocol ZENoNetViewDelegate{
    func reloadNetworkDataSource()
}

class ZENoNetView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var delegate:ZENoNetViewDelegate?
    @IBAction func reloadNetworkDataSource(sender: UIButton) {
        delegate?.reloadNetworkDataSource()
    }
    class func instanceNoNetView() -> ZENoNetView{
        var noNetView = ZENoNetView()
        let array = NSBundle.mainBundle().loadNibNamed("ZENoNetView", owner: nil, options: nil)
        noNetView = array.first as! ZENoNetView
        noNetView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        return noNetView
    }
}
