//
//  PublishViewController.swift
//  Baby
//
//  Created by YunTu on 2017/3/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class OthersViewController: UITableViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var selectViewCenterX: NSLayoutConstraint!
    
    var dataSource:NSDictionary?
    var userInfo:NSDictionary?
    var goodsList:NSArray = NSArray()
    
    var currentBtnTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = ""
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.avatar.layer.cornerRadius = 29
        self.selectViewCenterX.constant = -Helpers.screanSize().width / 4
        requestOtherInfo()
        print(dataSource!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public class func getInstance() -> OthersViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:"other")
        return vc as! OthersViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return goodsList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if currentBtnTag == 1 {
            cellIdentify = "Cell"
        }else {
            cellIdentify = "evaluateCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if currentBtnTag == 1 {
            let dic = goodsList[indexPath.section] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["app_default_image"] as! String))!)
            (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String) + "/天"
            (cell.viewWithTag(4) as! UILabel).text = "押金￥" + (dic["deposit"] as! String)
        }else {
            (cell as! MainCell).indexPath = indexPath
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
        if segue.destination.isKind(of: GoodsDetailViewController.self){
            let cell = sender as? UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell!)
            let dic = self.goodsList[indexPath!.section] as! NSDictionary
            let tempDic = NSMutableDictionary(dictionary: dic)
            tempDic.addEntries(from: self.userInfo as! [AnyHashable : Any])
            (segue.destination as! GoodsDetailViewController).orderInfo = tempDic
        }
    }
    
    
    @IBAction func typeBtnDidClick(_ sender: UIButton) {
        currentBtnTag = sender.tag
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            if sender.tag == 1 {
                self.selectViewCenterX.constant = -Helpers.screanSize().width / 4
            }else {
                self.selectViewCenterX.constant = Helpers.screanSize().width / 4
            }
            self.view.layoutIfNeeded()
        }
    }

    func requestOtherInfo() {
        SVProgressHUD.show()
        NetworkModel.requestGet(["app":"appsdefault","act":"memberindex","user_id":dataSource?["user_id"] as! String]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                self.requestPublishGoods()
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    self.userInfo = jsonDic
                    if jsonDic["portrait"] != nil &&  (jsonDic["portrait"] as! NSObject).isKind(of: NSString.self) && (jsonDic["portrait"] as! String) != "<null>" {
                        self.avatar.sd_setImage(with: URL(string: Helpers.baseImgUrl() + (jsonDic["portrait"] as! String))!)
                    }
                    self.nickname.text = jsonDic["nickname"] as? String
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }

    func requestPublishGoods() -> Void {
        SVProgressHUD.show()
        NetworkModel.requestGet(["app":"appsdefault","act":"membergoods","user_id":dataSource?["user_id"] as! String]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(jsonDic)
                    self.goodsList = jsonDic["my_onsalegoods"] as! NSArray
                    self.tableView.reloadData()
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }
    
}
