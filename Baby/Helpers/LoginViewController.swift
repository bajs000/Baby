//
//  LoginViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UITableViewController {

    @IBOutlet weak var accountTextField: PhoneTextField!
    @IBOutlet weak var passwordTextField: PhoneTextField!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        let height = Helpers.screanSize().height - 64 - 20 - 83 - 83
        self.footerView.frame = CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: height)
        self.tableView.tableFooterView = footerView
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav-back"), style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(goRegist))
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2549019608, green: 0.2235294118, blue: 0.3137254902, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2549019608, green: 0.2235294118, blue: 0.3137254902, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goBack() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goRegist() -> Void {
        self.performSegue(withIdentifier: "registPush", sender: nil)
    }
    
    // MARK: - Table view data source
    

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
    @IBAction func loginBtnDidClick(_ sender: Any) {
        if accountTextField.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        if (passwordTextField.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "密码必须大于等于6位")
            return
        }
        SVProgressHUD.show()
        NetworkModel.requestGet(["act":"login","user_name":accountTextField.text!,"password":passwordTextField.text!]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    let userDefault = UserDefaults.standard
                    userDefault.set(jsonDic["birth_date"], forKey: "BIRTHDAY")
                    userDefault.set(jsonDic["user_name"], forKey: "USERNAME")
                    userDefault.set(jsonDic["password"], forKey: "PASSWORDMD5")
                    userDefault.set(self.passwordTextField.text!, forKey: "PASSWORD")
                    userDefault.set(jsonDic["user_id"], forKey: "USERID")
                    userDefault.synchronize()
                    SVProgressHUD.showSuccess(withStatus: "登录成功")
                    self.dismiss(animated: true, completion: nil)
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }
    
    

}
