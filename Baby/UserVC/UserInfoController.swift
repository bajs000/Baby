//
//  UserInfoController.swift
//  Baby
//
//  Created by YunTu on 2017/3/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserInfoController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var avatarIcon: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    var avatarUrl:String?
    var gender = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        self.avatarIcon.layer.cornerRadius = 75
        self.birthdayTextField.inputView = datePicker
        self.datePicker.maximumDate = Date()
        self.avatarIcon.sd_setImage(with: URL(string: UserModel.share.avatar)!)
        self.nicknameTextField.text = UserModel.share.nickName
        self.birthdayTextField.text = UserModel.share.birthday
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
    
    // MARK: - UIImagePickerController delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.avatarIcon.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        UploadNetwork.request(["act":"up_laod_api","user_id":UserModel.share.userId,"vp":UserModel.share.password], data: (self.avatarIcon.image)!, paramName: "image") { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                print(dic)
                self.avatarUrl = (dic as! NSDictionary)["retval"] as? String
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

    @IBAction func avatarBtnDidClick(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "相机", style: .default, handler: { (action) in
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            imgPicker.sourceType = .savedPhotosAlbum
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.birthdayTextField.text = formatter.string(from: sender.date)
    }
    
    @IBAction func sexBtnDidClick(_ sender: UIButton) {
        if sender.tag == 1 {
            sender.superview?.viewWithTag(sender.tag + 11)?.isHidden = true
        }else {
            sender.superview?.viewWithTag(sender.tag + 9)?.isHidden = true
        }
        sender.superview?.viewWithTag(sender.tag + 10)?.isHidden = false
        self.gender = String(sender.tag)
    }
    
    @IBAction func rightBarItemDidClick(_ sender: Any) {
        if self.avatarIcon.image == nil {
            SVProgressHUD.showError(withStatus: "请选择头像")
            return
        }
        if self.nicknameTextField.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入昵称")
            return
        }
        if self.birthdayTextField.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请选择生日")
            return
        }
        SVProgressHUD.show()
        NetworkModel.requestGet(["act":"edit",
                                 "user_id":UserModel.share.userId,
                                 "vp":UserModel.share.password,
                                 "birth_date":self.birthdayTextField.text!,
                                 "gender":self.gender,
                                 "nickname":self.nicknameTextField.text!,
                                 "portrait":avatarUrl!,
                                 "is_post":"1"]) { (dic) in
                                    if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                                        SVProgressHUD.dismiss()
                                        _ = self.navigationController?.popViewController(animated: true)
                                    }else{
                                        SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
                                    }
        }
        
        
    }
}
