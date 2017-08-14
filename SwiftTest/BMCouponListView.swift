//
//  BMCouponListView.swift
//  SwiftTest
//  优惠券列表
//  Created by 张琳 on 2017/8/14.
//  Copyright © 2017年 张琳. All rights reserved.
//

import UIKit
import TBEmptyDataSet
import DGElasticPullToRefresh
import SwiftyJSON

enum CouponListFrom:NSInteger{  //优惠券是从哪个页面跳转过来的
    case me,order   //me  代表我的   order代表订单
}

class BMCouponListView: UITableViewController,TBEmptyDataSetDelegate,TBEmptyDataSetDataSource {

    
    var sourceFrom:CouponListFrom!  //判断是从哪个页面跳转过来的
    var dataList:Array<JSON>?  //数据源
    
    
    /**
     * 初始化页面
     * @param sourceFrom 是从哪个页面跳转过来的   枚举类型 
     */
    init(sourceFrom:CouponListFrom) {
        
        self.sourceFrom = sourceFrom
        super.init(style: .plain)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "优惠券"
        self.tableView.backgroundColor = UIColor.colorWithHexString(hex: BMBacgroundColor)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none  //去掉分割线
        self.tableView.rowHeight = 119
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "BMCouponCell", bundle: nil), forCellReuseIdentifier: "BMCouponCell")
        self.tableView.emptyDataSetDelegate = self  //设置空数据的代理
        self.tableView.emptyDataSetDataSource = self  //设置空数据的数据源
        
        
        ///////////显示头部刷新视图//////////////////
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        self.tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in //刷新回调
            
            self?.loadData()   //请求数据
            
            }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor.colorWithHexString(hex: BMThemeColor)) //设置头部刷新视图的背景色
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!) //设置头部刷新指示器的颜色
        
        self.loadData()//请求数据

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh() //移除头部刷新视图
    }
    
    
    /**
     * 请求数据
     */
    func loadData() {
        
        
        
        
        //////////////请求优惠券///////////////////
        let url = "\(BMHOST)/c/coupon/queryList"
        var params:Dictionary<String,Any> = ["":""]
        
        
        if self.sourceFrom == CouponListFrom.me{
            params = ["status":0,"expireFlag":0,"pageSize":10000,"pageNum":0]
            
        }else if self.sourceFrom == CouponListFrom.order{
            params = ["status":0,"expireFlag":0,"pageSize":10000,"pageNum":0]
        }
        
        NetworkRequest.sharedInstance.postRequest(urlString: url, params: params, isLogin: true, success: { (value) in
            
            self.tableView.dg_stopLoading()  //停止刷新动画
            self.dataList = value["dataList"].array
            self.tableView.reloadData()
            
        }) { (error) in
            
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let dataList = self.dataList{
            return dataList.count
        }else{
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BMCouponCell = tableView.dequeueReusableCell(withIdentifier: "BMCouponCell", for: indexPath) as! BMCouponCell
        cell.updateWithCoupons(coupon: self.dataList![indexPath.row])
        
        return cell
    }
 

   

}
