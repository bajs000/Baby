//
//  AddAddressViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/18.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddAddressViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var defaultBtn: UIButton!
    var titleArr = [["title":"收货人:","detail":"","placeholder":"收货人姓名","cellIdentify":"normalCell"],
                    ["title":"手机号:","detail":"","placeholder":"收货人手机号","cellIdentify":"normalCell"],
                    ["title":"所在区域:","detail":"","placeholder":"收货人所在区域","cellIdentify":"normalCell"],
                    ["title":"详细地址:","detail":"","placeholder":"建议您如实填写详细地址，例如街道名称，门牌号，楼层和房间号","cellIdentify":"detailCell"]]
    var editAddressDic:NSDictionary?{
        didSet{
            titleArr = [["title":"收货人:","detail":editAddressDic!["consignee"] as! String,"placeholder":"收货人姓名","cellIdentify":"normalCell"],
                        ["title":"手机号:","detail":editAddressDic!["phone_mob"] as! String,"placeholder":"收货人手机号","cellIdentify":"normalCell"],
                        ["title":"所在区域:","detail":editAddressDic!["region_name"] as! String,"placeholder":"收货人所在区域","cellIdentify":"normalCell"],
                        ["title":"详细地址:","detail":editAddressDic!["address"] as! String,"placeholder":"建议您如实填写详细地址，例如街道名称，门牌号，楼层和房间号","cellIdentify":"detailCell"]]
        }
    }
    var placeHolder: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加地址"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        requestUserLocation()
        if editAddressDic != nil {
            self.defaultBtn.isSelected = ((editAddressDic!["default_"] as! String) == "1")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: titleArr[indexPath.row]["cellIdentify"]!, for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = titleArr[indexPath.row]["title"]
        if indexPath.row < 3 {
            (cell.viewWithTag(2) as! UITextField).placeholder = titleArr[indexPath.row]["placeholder"]
            (cell.viewWithTag(2) as! UITextField).text = titleArr[indexPath.row]["detail"]
            (cell.viewWithTag(2) as! UITextField).keyboardType = .default
            if indexPath.row == 1 {
                (cell.viewWithTag(2) as! UITextField).keyboardType = .numberPad
            }
            (cell.viewWithTag(2) as! UITextField).addTarget(self, action: #selector(textFieldDidChane(_:)), for: .editingChanged)
        }else{
            placeHolder = (cell.viewWithTag(2) as! UILabel)
            if  (titleArr[indexPath.row]["detail"]?.characters.count)! > 0{
                placeHolder?.isHidden = true
            }else{
                placeHolder?.isHidden = false
            }
            (cell.viewWithTag(2) as! UILabel).text = titleArr[indexPath.row]["placeholder"]
            (cell.viewWithTag(3) as! UITextView).text = titleArr[indexPath.row]["detail"]
            (cell.viewWithTag(3) as! UITextView).delegate = self
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

    // MARK: - UITextView delegate
    func textViewDidChange(_ textView: UITextView) {
        self.placeHolder?.isHidden = (textView.text.characters.count > 0)
        var tempDic = self.titleArr[3]
        tempDic["detail"] = textView.text
        self.titleArr.remove(at: 3)
        self.titleArr.insert(tempDic, at: 3)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func textFieldDidChane(_ textField: UITextField) {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: textField)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        var tempDic = self.titleArr[indexPath!.row]
        tempDic["detail"] = textField.text
        self.titleArr.remove(at: indexPath!.row)
        self.titleArr.insert(tempDic, at: indexPath!.row)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func defaultBtnDidClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        for dic in titleArr {
            if dic["detail"]?.characters.count == 0 {
                SVProgressHUD.showError(withStatus: "请输入" + dic["placeholder"]!)
                return
            }
        }
        var defaultPlace = "0"
        if defaultBtn.isSelected {
            defaultPlace = "1"
        }
        var param = ["app":"AppsMy_address",
                     "act":"add",
                     "user_id":UserModel.share.userId,
                     "vp":UserModel.share.password,
                     "phone_mob":titleArr[1]["detail"]!,
                     "region_name":titleArr[2]["detail"]!,
                     "address":titleArr[3]["detail"]!,
                     "default_":defaultPlace,
                     "consignee":titleArr[0]["detail"]!]
        if editAddressDic != nil {
            param["addr_id"] = editAddressDic!["addr_id"] as? String
            param["act"] = "edit"
        }
        SVProgressHUD.show()
        NetworkModel.requestGet(param as NSDictionary) { (dic) in
                                    if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                                        SVProgressHUD.showSuccess(withStatus: "添加成功")
                                        _ = self.navigationController?.popViewController(animated: true)
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
                print(dic)
                var tempDic = self.titleArr[2]
                if ((((dic as! NSDictionary)["regeocode"] as! NSDictionary)["addressComponent"] as! NSDictionary)["city"] as! NSObject).isKind(of: NSString.self) {
                    tempDic["detail"] = ((((dic as! NSDictionary)["regeocode"] as! NSDictionary)["addressComponent"] as! NSDictionary)["province"] as! String) + ((((dic as! NSDictionary)["regeocode"] as! NSDictionary)["addressComponent"] as! NSDictionary)["city"] as! String) + ((((dic as! NSDictionary)["regeocode"] as! NSDictionary)["addressComponent"] as! NSDictionary)["district"] as! String) + ((((dic as! NSDictionary)["regeocode"] as! NSDictionary)["addressComponent"] as! NSDictionary)["township"] as! String)
                }else{
                    tempDic["detail"] = ((((dic as! NSDictionary)["regeocode"] as! NSDictionary)["addressComponent"] as! NSDictionary)["province"] as! String) + ((((dic as! NSDictionary)["regeocode"] as! NSDictionary)["addressComponent"] as! NSDictionary)["district"] as! String) + ((((dic as! NSDictionary)["regeocode"] as! NSDictionary)["addressComponent"] as! NSDictionary)["township"] as! String)
                }
                self.titleArr.remove(at: 2)
                self.titleArr.insert(tempDic, at: 2)
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }else {
                SVProgressHUD.showError(withStatus: "定位错误")
            }
        }
    }

}
