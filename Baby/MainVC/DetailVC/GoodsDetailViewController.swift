//
//  GoodsDetailViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class GoodsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var imgArr = [String]()
    var imgHeightDic = [String:CGFloat]()
    var pushByOther = true
    
    var orderInfo:NSDictionary?{
        didSet{
            if orderInfo!["img1"] != nil && (orderInfo!["img1"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img1"] as! String).characters.count > 0 {
                imgArr.append((orderInfo!["img1"] as! String))
                imgHeightDic["1"] = 50
            }
            if orderInfo!["img2"] != nil && (orderInfo!["img2"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img2"] as! String).characters.count > 0 {
                imgArr.append((orderInfo!["img2"] as! String))
                imgHeightDic["2"] = 50
            }
            if orderInfo!["img3"] != nil && (orderInfo!["img3"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img3"] as! String).characters.count > 0 {
                imgArr.append((orderInfo!["img3"] as! String))
                imgHeightDic["3"] = 50
            }
            if orderInfo!["img4"] != nil && (orderInfo!["img4"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img4"] as! String).characters.count > 0 {
                imgArr.append((orderInfo!["img4"] as! String))
                imgHeightDic["4"] = 50
            }
            if orderInfo!["img5"] != nil && (orderInfo!["img5"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img5"] as! String).characters.count > 0 {
                imgArr.append((orderInfo!["img5"] as! String))
                imgHeightDic["5"] = 50
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "宝贝详情"
        self.tableView.estimatedRowHeight = 100
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        requestDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.perform(#selector(resetTable), with: nil, afterDelay: 0.1)
    }
    
    func resetTable() -> Void {
        if self.pushByOther {
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 50, 0)
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + imgArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }else{
            return self.imgHeightDic[String(indexPath.row)]!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.row ==  0{
            cellIdentify = "infoCell"
        }else{
            cellIdentify = "imgCell"
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.row ==  0{
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: (Helpers.baseImgUrl() + (orderInfo?["portrait"] as! String) as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)!)
            cell.viewWithTag(1)?.layer.cornerRadius = 29
            (cell.viewWithTag(2) as! UILabel).text = orderInfo?["user_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (orderInfo!["price"] as! String) + "/天"
            (cell.viewWithTag(5) as! UILabel).text = orderInfo!["description"] as? String
        }else{
//            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + imgArr[indexPath.row - 1])!)
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + imgArr[indexPath.row - 1])!, completed: { (image, error, type, url) in
                let width = Helpers.screanSize().width - 24
                let height = width * (image?.size.height)! / (image?.size.width)!
                if self.imgHeightDic[String(indexPath.row)] != height{
                    self.imgHeightDic[String(indexPath.row)] = height
                    self.tableView.reloadData()
                }
            })
        }
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
        if segue.identifier == "surePush" {
            (segue.destination as! SureOrderViewController).orderInfo = orderInfo
        }
    }
    
    @IBAction func storeBtnDidClick(_ sender: Any) {
        SVProgressHUD.show()
        NetworkModel.requestGet(["act":"add_mycarts","user_id":UserModel.share.userId,"vp":UserModel.share.password,"goods_id":orderInfo!["goods_id"] as! String]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.showSuccess(withStatus: "收藏成功")
                self.dismiss(animated: true, completion: nil)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }
    
//    func requestDetail() -> Void {
//        SVProgressHUD.show()
//        NetworkModel.requestGet(["app":"appsdefault","act":"index","goods_id":"534"]) { (dic) in
//            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
//                SVProgressHUD.dismiss()
//                let userInfo = (dic as! NSDictionary)["retval"] as! String
//                let data = userInfo.data(using: .utf8)
//                do {
//                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
//                    print(jsonDic)
//                    self.dataSource = jsonDic["data"] as? NSArray
////                    self.tableView.reloadData()
//                }catch{
//                    
//                }
//            }else{
//                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
//            }
//        }
//    }

}
