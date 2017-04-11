//
//  PublishViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/10.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class PublishGoodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    var titleTextField:UITextField?
    var detailTextField:UITextView?
    var imgArr = [UIImage]()
    var imgUrlArr = [String]()
    var locationLabel:UILabel?
    var priceTextField:UITextField?
    var depositTextField:UITextField?
    var freightTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.title = "发布玩具"
        requestUserLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func keyboardWillShow(_ notification: Notification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: duration) {
            self.tableViewBottom.constant = keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.tableViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cellIdentify = "titleCell"
            }else if indexPath.row == 1 {
                cellIdentify = "detailCell"
            }else if indexPath.row == 2 {
                cellIdentify = "imgCell"
            }else if indexPath.row == 3 {
                cellIdentify = "locationCell"
            }
        }else{
            if indexPath.row == 0 {
                cellIdentify = "priceCell"
            }else if indexPath.row == 1 {
                cellIdentify = "depositCell"
            }else if indexPath.row == 2 {
                cellIdentify = "freightCell"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                titleTextField = cell.viewWithTag(1) as? UITextField
            }else if indexPath.row == 1 {
                (cell.viewWithTag(1) as! UITextView).delegate = self
                detailTextField = cell.viewWithTag(1) as? UITextView
            }else if indexPath.row == 2 {
                (cell as! PublishCell).vc = self
            }else if indexPath.row == 3 {
                locationLabel = cell.viewWithTag(1) as? UILabel
            }
        }else{
            if indexPath.row == 0 {
                priceTextField = cell.viewWithTag(1) as? UITextField
            }else if indexPath.row == 1 {
                depositTextField = cell.viewWithTag(1) as? UITextField
            }else if indexPath.row == 2 {
                freightTextField = cell.viewWithTag(1) as? UITextField
            }
        }
        return cell
    }
    
    //MARK: - UITextView delegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            textView.superview?.viewWithTag(2)?.isHidden = true
        }else {
            textView.superview?.viewWithTag(2)?.isHidden = false
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
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
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func publishBtnDidClick(_ sender: Any) {
        if titleTextField?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入标题")
            return
        }
        if detailTextField?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入闲置玩具内容")
            return
        }
        if priceTextField?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入价格")
            return
        }
        if depositTextField?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入押金")
            return
        }
        SVProgressHUD.show()
        var param = [String:String]()
        param = ["act":"upload_goods",
                 "user_id":UserModel.share.userId,
                 "vp":UserModel.share.password,
                 "price":priceTextField!.text!,
                 "deposit":depositTextField!.text!,
                 "description":detailTextField!.text,
                 "goods_name":titleTextField!.text!,
                 "longitude":String(Helpers.longitude),
                 "latitude":String(Helpers.latitude),
                 "region_name":locationLabel!.text!]
        if self.imgUrlArr.count > 0 {
            param["app_default_image"] = self.imgUrlArr[0]
            var i = 1
            for url in self.imgUrlArr {
                param["img" + String(i)] = url
                i = i + 1
            }
        }
        NetworkModel.requestGet(param as NSDictionary) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                self.dismiss(animated: true, completion: nil)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
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
