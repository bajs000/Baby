//
//  SureOrderViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/24.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class SureOrderViewController: UITableViewController {

    @IBOutlet weak var goodsIcon: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsDeposit: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var payWay: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var freightLabel: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var balancePayIcon: UIImageView!
    @IBOutlet weak var alipayIcon: UIImageView!
    @IBOutlet weak var wechatIcon: UIImageView!
    
    var orderInfo:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认订单"
        balancePayIcon.layer.cornerRadius = 10
        balancePayIcon.layer.borderColor = UIColor.colorWithHexString(hex: "e1e1e1").cgColor
        balancePayIcon.layer.borderWidth = 1
        alipayIcon.layer.cornerRadius = 10
        alipayIcon.layer.borderColor = UIColor.colorWithHexString(hex: "e1e1e1").cgColor
        alipayIcon.layer.borderWidth = 1
        wechatIcon.layer.cornerRadius = 10
        wechatIcon.layer.borderColor = UIColor.colorWithHexString(hex: "e1e1e1").cgColor
        wechatIcon.layer.borderWidth = 1
        print(orderInfo!)
        
        goodsIcon.sd_setImage(with: URL(string: (Helpers.baseImgUrl() + (orderInfo?["app_default_image"] as! String) as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)!)
        goodsName.text = orderInfo?["goods_name"] as? String
        goodsPrice.text = "￥" + (orderInfo?["price"] as! String) + "/天"
        goodsDeposit.text = "押金￥" + (orderInfo?["deposit"] as! String)
        
        requestUserLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.perform(#selector(resetTable), with: nil, afterDelay: 0.1)
    }
    
    func resetTable() -> Void {
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if indexPath.row == 1 {
                balancePayIcon.image = #imageLiteral(resourceName: "user-sex-select")
                alipayIcon.image = nil
                wechatIcon.image = nil
            }else if indexPath.row == 2 {
                alipayIcon.image = #imageLiteral(resourceName: "user-sex-select")
                balancePayIcon.image = nil
                wechatIcon.image = nil
            }else if indexPath.row == 3 {
                wechatIcon.image = #imageLiteral(resourceName: "user-sex-select")
                alipayIcon.image = nil
                balancePayIcon.image = nil
            }
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sureToPayDidClick(_ sender: Any) {
        
    }
    
    func requestUserLocation() -> Void {
        SVProgressHUD.show()
        NetworkModel.requestLocation(url: "http://restapi.amap.com/v3/geocode/regeo?key=6632969fe0929070d2cd5c2a50f27ca9&location=" + String(Helpers.longitude) + "," + String(Helpers.latitude)) { (dic) in
            print(dic)
            if Int((dic as! NSDictionary)["status"] as! String) == 1 {
                self.locationLabel?.text = ((dic as! NSDictionary)["regeocode"] as! NSDictionary)["formatted_address"] as? String
                SVProgressHUD.dismiss()
            }else {
                SVProgressHUD.showError(withStatus: "定位错误")
            }
        }
    }

}
