//
//  RegistViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistViewController: UITableViewController {

    @IBOutlet weak var textFieldBg: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyTextField: CodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        self.textFieldBg.layer.cornerRadius = 8
        self.verifyTextField.sendCodeBtn?.addTarget(self, action: #selector(sendCodeBtnDidClick(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
    
    func sendCodeBtnDidClick(_ sender: UIButton) -> Void {
        if accountTextField.text?.characters.count == 11 {
            SVProgressHUD.show()
            NetworkModel.requestGet(["act":"get_reg_code","phone":accountTextField.text!]) { (dic) in
                self.verifyTextField.startCount()
                SVProgressHUD.dismiss()
            }
        }else{
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
        }
    }
    
    @IBAction func registBtnDidClick(_ sender: Any) {
        if accountTextField.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        if (passwordTextField.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "密码必须大于等于6位")
            return
        }
        if verifyTextField.text?.characters.count != 6 {
            SVProgressHUD.showError(withStatus: "请正确输入验证码")
            return
        }
        SVProgressHUD.show()
        NetworkModel.requestGet(["act":"register","user_name":accountTextField.text!,"password":passwordTextField.text!,"reg_code":verifyTextField.text!]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                print(dic)
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
                    SVProgressHUD.showSuccess(withStatus: "注册成功")
                    self.dismiss(animated: true, completion: nil)
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }

}
