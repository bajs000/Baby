//
//  UserInfoController.swift
//  Baby
//
//  Created by YunTu on 2017/3/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class UserInfoController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var avatarIcon: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        self.avatarIcon.layer.cornerRadius = 75
        self.birthdayTextField.inputView = datePicker
        self.datePicker.maximumDate = Date()
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
    }
    
    @IBAction func rightBarItemDidClick(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
