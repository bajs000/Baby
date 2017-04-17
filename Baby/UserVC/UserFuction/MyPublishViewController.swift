//
//  MyPublishViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/12.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

enum PublishType {
    case onsale
    case offsale
}

class MyPublishViewController: UITableViewController {

    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我发布的"
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "已下架", style: .plain, target: self, action: #selector(soldOutBarBtnDidClick(_:)))
        self.requestPublishList(.onsale)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = dataSource[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["app_default_image"] as! String))!)
        (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
        (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String) + "/天"
        (cell.viewWithTag(4) as! UILabel).text = "押金￥" + (dic["deposit"] as! String)
        var tempStr = NSMutableAttributedString(string: (cell.viewWithTag(4) as! UILabel).text!)
        tempStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexString(hex: "f74641"), range: NSMakeRange(2, (cell.viewWithTag(4) as! UILabel).text!.characters.count - 2))
        (cell.viewWithTag(4) as! UILabel).attributedText = tempStr
        (cell.viewWithTag(5) as! UILabel).text = "当前状态：" + (dic["goods_name"] as! String)
        tempStr = NSMutableAttributedString(string: (cell.viewWithTag(5) as! UILabel).text!)
        tempStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexString(hex: "f74641"), range: NSMakeRange(5, (cell.viewWithTag(5) as! UILabel).text!.characters.count - 5))
        (cell.viewWithTag(5) as! UILabel).attributedText = tempStr
        
        cell.viewWithTag(6)?.layer.cornerRadius = 4
        cell.viewWithTag(6)?.layer.borderColor = UIColor.colorWithHexString(hex: "e1e1e1").cgColor
        cell.viewWithTag(6)?.layer.borderWidth = 1
        if self.title == "已下架" {
            (cell.viewWithTag(6) as! UIButton).setTitle("上架", for: .normal)
            (cell.viewWithTag(7) as! UIButton).setTitle("上架", for: .normal)
            cell.viewWithTag(6)?.isHidden = true
        }else{
            cell.viewWithTag(6)?.isHidden = false
            (cell.viewWithTag(6) as! UIButton).setTitle("编辑", for: .normal)
        }
        (cell.viewWithTag(6) as! UIButton).addTarget(self, action: #selector(editBtnDidClick(_:)), for: .touchUpInside)
        
        cell.viewWithTag(7)?.layer.cornerRadius = 4
        cell.viewWithTag(7)?.layer.borderColor = UIColor.colorWithHexString(hex: "e1e1e1").cgColor
        cell.viewWithTag(7)?.layer.borderWidth = 1
        
        (cell.viewWithTag(7) as! UIButton).addTarget(self, action: #selector(editBtnDidClick(_:)), for: .touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let dic = dataSource[indexPath.row] as! NSDictionary
        print(dic)
        SVProgressHUD.show()
        NetworkModel.requestGet(["act":"delete_goods","user_id":UserModel.share.userId,"vp":UserModel.share.password,"goods_id":dic["goods_id"] as! String]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                let tempArr = NSMutableArray(array: self.dataSource)
                tempArr.removeObject(at: indexPath.row)
                self.dataSource = tempArr
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func soldOutBarBtnDidClick(_ sender: UIBarButtonItem) -> Void {
        if sender.title == "已下架" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "我的发布", style: .plain, target: self, action: #selector(soldOutBarBtnDidClick(_:)))
            self.requestPublishList(.offsale)
            self.title = "已下架"
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "已下架", style: .plain, target: self, action: #selector(soldOutBarBtnDidClick(_:)))
            self.requestPublishList(.onsale)
            self.title = "我的发布"
        }
    }
    
    func editBtnDidClick(_ sender:UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = dataSource[(indexPath?.row)!] as! NSDictionary
        if sender.currentTitle == "上架" {
            SVProgressHUD.show()
            NetworkModel.requestGet(["act":"onsale","goods_id":dic["goods_id"] as! String,"user_id":UserModel.share.userId,"vp":UserModel.share.password], complete: { (dic) in
                if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                    SVProgressHUD.dismiss()
                    self.requestPublishList(.offsale)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
                }
            })
        }else if sender.currentTitle == "下架"{
            SVProgressHUD.show()
            NetworkModel.requestGet(["act":"offsale","goods_id":dic["goods_id"] as! String,"user_id":UserModel.share.userId,"vp":UserModel.share.password], complete: { (dic) in
                if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                    SVProgressHUD.dismiss()
                    self.requestPublishList(.onsale)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
                }
            })
        }
    }
    
    func requestPublishList(_ type:PublishType) -> Void {
        SVProgressHUD.show()
        var param = ["act":"mygoods_onsale","user_id":UserModel.share.userId,"vp":UserModel.share.password,"page":"1"]
        if type == .offsale {
            param["act"] = "mygoods_offsale"
        }
        NetworkModel.requestGet(param as NSDictionary) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    self.dataSource = jsonDic["my_onsalegoods"] as! NSArray
                    self.tableView.reloadData()
                }catch{
                    
                }
            }else{
                self.dataSource = NSArray()
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }
    
}
