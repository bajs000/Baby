//
//  OrderDetailViewController.swift
//  Baby
//
//  Created by yuzhengzhou on 2017/5/11.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var orderInfo:NSDictionary?
    var orderDetail:NSDictionary?
    var type:HireType = HireType.rent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        requestDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.clear
        return v
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.section == 0 {
            cellIdentify = "headerCell"
        }else {
            if indexPath.row == 0 {
                cellIdentify = "userCell"
            }else{
                cellIdentify = "priceCell"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if orderDetail != nil {
            if indexPath.section == 0 {
                (cell.viewWithTag(1) as! UILabel).text = (orderDetail?["order_detail"] as! NSDictionary)["status_name"] as? String
                (cell.viewWithTag(2) as! UILabel).text = "订单号：" + ((orderDetail?["order_detail"] as! NSDictionary)["order_id"] as! String)
                (cell.viewWithTag(3) as! UILabel).text = "下单时间：" + Helpers.timeChange((orderDetail?["order_detail"] as! NSDictionary)["add_time"] as! String)
            }else {
                if indexPath.row == 0 {
                    (cell.viewWithTag(1) as! UILabel).text = "对方信息：  " + ((orderDetail?["order_detail"] as! NSDictionary)["seller_name"] as! String)
                    (cell.viewWithTag(2) as! UILabel).text = "地址："// + ((orderDetail?["order_detail"] as! NSDictionary)["order_id"] as! String)
                }else{
                    (cell.viewWithTag(1) as! UILabel).text = (orderDetail?["order_detail"] as! NSDictionary)["payment_name"] as? String
                    (cell.viewWithTag(2) as! UILabel).text = (orderDetail?["order_detail"] as! NSDictionary)["rent_days"] as! String + "天"
                    let dic = (orderDetail?["goods_lists"] as! NSArray)[0] as! NSDictionary
                    (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String)
                    (cell.viewWithTag(4) as! UILabel).text = "￥" + (dic["price"] as! String)
                    (cell.viewWithTag(5) as! UILabel).text = "￥" + ((orderDetail?["order_detail"] as! NSDictionary)["goods_amount"] as! String)
                }
            }
        }
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func requestDetail() -> Void {
        SVProgressHUD.show()
        NetworkModel.requestGet(["app":"appsorder","act":"buyer_order_detail","user_id":UserModel.share.userId,"vp":UserModel.share.password,"order_id":orderInfo?["order_id"] as! String]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 0 {
                SVProgressHUD.dismiss()
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(jsonDic)
                    self.orderDetail = jsonDic
                    self.tableView.reloadData()
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }
    
}
