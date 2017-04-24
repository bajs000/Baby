//
//  MainViewController.swift
//  Baby
//
//  Created by YunTu on 2017/3/14.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class MainViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var headerCollectinView: UICollectionView!
    @IBOutlet var headerView: UIView!

    var requestIng:Bool = false
    var dataSource:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "重庆", style: .plain, target: self, action: #selector(leftBarItemDidClick))
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        self.navigationItem.titleView = searchBar
        searchBar.clipsToBounds = true
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.delegate = self.tabBarController as? UINavigationControllerDelegate
        searchBar.delegate = self
        
        Helpers.completeLocation = {
            if !self.requestIng {
                self.requestMain()
            }
        }
        Helpers.locationManager()
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
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    func keyboardWillHide(_ notification: Notification) -> Void {
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 55
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.headerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.clear
        return v
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = self.dataSource[indexPath.section] as! NSDictionary
        (cell as! MainCell).indexPath = indexPath
        
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: (Helpers.baseImgUrl() + (dic["portrait"] as! String) as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)!)
        cell.viewWithTag(1)?.layer.cornerRadius = 29
        (cell.viewWithTag(2) as! UILabel).text = dic["user_name"] as? String
        (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String) + "/天"
        (cell as! MainCell).orderInfo = dic
        (cell.viewWithTag(5) as! UILabel).text = dic["description"] as? String
        (cell.viewWithTag(6) as! UILabel).text = "来自" + (dic["region_name"] as! String)
        (cell.viewWithTag(7) as! UIButton).addTarget(self, action: #selector(avatarBtnDidClick(_:)), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailPush", sender: indexPath)
    }
    
    // MARK:- UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }

    func cutCricleOnBackView(byView:UIView,centerPoint:CGPoint,radius:CGFloat) {
        let path = UIBezierPath(rect: byView.bounds)
        let circle = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(Double.pi), clockwise: false)
        path.append(circle)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        byView.layer.mask = maskLayer
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

    // MARK: - UISearchBarDelegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.performSegue(withIdentifier: "searchPush", sender: nil)
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: GoodsDetailViewController.self){
            let indexPath = sender as? IndexPath
            let dic = self.dataSource[indexPath!.section] as! NSDictionary
            (segue.destination as! GoodsDetailViewController).orderInfo = dic
            (segue.destination as! GoodsDetailViewController).pushByOther = false
        }
    }
    
    func avatarBtnDidClick(_ sender: UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = self.dataSource[(indexPath?.section)!] as! NSDictionary
        let vc = OthersViewController.getInstance()
        vc.dataSource = dic
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func leftBarItemDidClick() -> Void {
        UIApplication.shared.keyWindow?.endEditing(true)
    }

    func requestMain() -> Void {
        SVProgressHUD.show()
        requestIng = true
        NetworkModel.requestGet(["app":"appsdefault","act":"index","longitude":String(Helpers.longitude),"latitude":String(Helpers.latitude)]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    self.dataSource = jsonDic["data"] as! NSArray
                    self.tableView.reloadData()
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }
    
}
