//
//  AddressViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/12.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddressViewController: UITableViewController {

    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收货地址"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        requestAddress()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = dataSource[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UILabel).text = dic["consignee"] as? String
        (cell.viewWithTag(2) as! UILabel).text = dic["phone_mob"] as? String
        (cell.viewWithTag(3) as! UILabel).text = dic["region_name"] as! String + (dic["address"] as! String)
        (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(defaultBtnDidClick(_:)), for: .touchUpInside)
        (cell.viewWithTag(4) as! UIButton).isSelected = ((dic["default_"] as! String) == "1")
        
        (cell.viewWithTag(5) as! UIButton).addTarget(self, action: #selector(editBtnDidClick(_:)), for: .touchUpInside)
        (cell.viewWithTag(6) as! UIButton).addTarget(self, action: #selector(deleteBtnDidClick(_:)), for: .touchUpInside)
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
        if segue.identifier == "editPush" {
            let add = segue.destination as! AddAddressViewController
            add.editAddressDic = (sender as! NSDictionary)
        }
    }
    

    func defaultBtnDidClick(_ sender: UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = dataSource[indexPath!.row] as! NSDictionary
        NetworkModel.requestGet(["app":"AppsMy_address",
                                 "act":"set_default",
                                 "user_id":UserModel.share.userId,
                                 "vp":UserModel.share.password,
                                "addr_id":dic["addr_id"] as! String]) { (dic) in
                                    if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                                        self.requestAddress()
                                    }else{
                                        SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
                                    }
        }
    }
    
    func editBtnDidClick(_ sender: UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = dataSource[indexPath!.row] as! NSDictionary
        self.performSegue(withIdentifier: "editPush", sender: dic)
    }
    
    func deleteBtnDidClick(_ sender: UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = dataSource[indexPath!.row] as! NSDictionary
        NetworkModel.requestGet(["app":"AppsMy_address",
                                 "act":"drop",
                                 "user_id":UserModel.share.userId,
                                 "vp":UserModel.share.password,
                                 "addr_id":dic["addr_id"] as! String]) { (dic) in
                                    if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                                        self.requestAddress()
                                    }else{
                                        SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
                                    }
        }
    }
    
    func requestAddress() -> Void {
        SVProgressHUD.show()
        NetworkModel.requestGet(["app":"AppsMy_address",
                                 "act":"index",
                                 "user_id":UserModel.share.userId,
                                 "vp":UserModel.share.password]) { (dic) in
                                    if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                                        SVProgressHUD.dismiss()
                                        let userInfo = (dic as! NSDictionary)["retval"] as! String
                                        let data = userInfo.data(using: .utf8)
                                        do {
                                            let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
                                            self.dataSource = jsonDic
                                            self.tableView.reloadData()
                                        }catch{
                                            
                                        }
                                    }else{
                                        SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
                                    }
        }
    }
    
    
    
}
