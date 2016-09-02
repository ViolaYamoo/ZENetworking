//
//  ViewController.swift
//  ZENetworking
//
//  Created by zhangll on 16/8/31.
//  Copyright © 2016年 zhangll. All rights reserved.
//

import UIKit

class ViewController: ZEViewController ,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        ZEResource.printGrowth(golds, waters: waters, oils: oils)
        ZEResource.printGrowth(golds2, waters: waters2, oils: oils2)

    }

    override func reloadNetworkDataSource() {
        self.hiddenNonetWork()
        reloadData()
    }
    
    func reloadData(){
        let params = ["pager.currentPage":1,
                      "pager.pageSize":10,
                      "queryInfo.sourceType":2]
        ZENetRequest.getList(params, successClose: { (listArray) in
            self.dataArray = (listArray as? NSMutableArray)!
            self.tableView.reloadData()
            
        }) { (error) in
            self.showNonetWork()
            print(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.textLabel?.text = dataArray[indexPath.row] as? String
        return cell
    }
}

