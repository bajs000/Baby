//
//  HireViewController.swift
//  Baby
//
//  Created by YunTu on 2017/3/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

enum HireType {
    case hire
    case rent
}

class HireViewController: UITableViewController {

    var type = HireType.rent
    var goodsList = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .rent {
            self.title = "我租出的"
        }else {
            self.title = "我租到的"
        }
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        requestPublishGoods()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goodsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let dic = goodsList[indexPath.section] as! NSDictionary
//        if type == .hire {
            let dict = ((goodsList[indexPath.section] as! NSDictionary)["goods_lists"] as! NSArray)[0] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dict["goods_image"] as! String))!)
            (cell.viewWithTag(2) as! UILabel).text = dict["goods_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dict["price"] as! String) + "/天"
            (cell.viewWithTag(4) as! UILabel).text = "押金￥" + (dic["rent_deposit"] as! String)
            (cell.viewWithTag(5) as! UILabel).text = dic["order_amount"] as? String
//        }else {
//            
//            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["app_default_image"] as! String))!)
//            (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
//            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String) + "/天"
//            (cell.viewWithTag(4) as! UILabel).text = "押金￥" + (dic["deposit"] as! String)
//            var price = 0.0;
//            if dic["price"] != nil && (dic["price"] as! NSObject).isKind(of: NSString.self) && (dic["price"] as! String).characters.count > 0 {
//                price = Double(dic["price"] as! String)!
//            }
//            if dic["deposit"] != nil && (dic["deposit"] as! NSObject).isKind(of: NSString.self) && (dic["deposit"] as! String).characters.count > 0 {
//                price = price + Double(dic["deposit"] as! String)!
//            }
//            (cell.viewWithTag(5) as! UILabel).text = String(price)
//        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail = segue.destination as! OrderDetailViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        detail.orderInfo = goodsList[(indexPath?.row)!] as? NSDictionary
        detail.type = type
    }
    
    
    func requestPublishGoods() -> Void {
        SVProgressHUD.show()
        var dic = ["app":"appsorder","act":"sller_order_list","user_id":UserModel.share.userId,"vp":UserModel.share.password]
        if type == .hire {
            dic = ["app":"appsorder","act":"buyer_order_list","user_id":UserModel.share.userId,"vp":UserModel.share.password,"order_status":"2"]
        }
        NetworkModel.requestGet(dic as NSDictionary) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(jsonDic)
                    self.goodsList = jsonDic["my_order_lists"] as! NSArray
                    self.tableView.reloadData()
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }

}
