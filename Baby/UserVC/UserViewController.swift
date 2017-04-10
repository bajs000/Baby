//
//  UserViewController.swift
//  Baby
//
//  Created by YunTu on 2017/3/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class UserViewController: UITableViewController {

    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var depositLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0)
        self.avatar.layer.cornerRadius = 29
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestUserInfo()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
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
        if  segue.identifier == "rentPush" {
            let vc = segue.destination as! HireViewController
            vc.type = .rent
        }else if segue.identifier == "hirePush" {
            let vc = segue.destination as! HireViewController
            vc.type = .hire
        }
    }
    

    func requestUserInfo() -> Void{
        SVProgressHUD.show()
        NetworkModel.requestGet(["act":"index","user_id":UserModel.share.userId,"vp":UserModel.share.password]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    let userDefault = UserDefaults.standard
                    userDefault.set(jsonDic["nickname"], forKey: "NICKNAME")
                    self.nickName.text = jsonDic["nickname"] as? String
                    if jsonDic["portrait"] != nil &&  (jsonDic["portrait"] as! NSObject).isKind(of: NSString.self) && (jsonDic["portrait"] as! String) != "<null>" {
                        self.avatar.sd_setImage(with: URL(string: Helpers.baseImgUrl() + (jsonDic["portrait"] as! String))!)
                        userDefault.set(Helpers.baseImgUrl() + (jsonDic["portrait"] as! String), forKey: "AVATAR")
                    }
                    self.moneyLabel.text = jsonDic["balance"] as? String
                    self.depositLabel.text = jsonDic["deposit"] as? String
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }
    
}
