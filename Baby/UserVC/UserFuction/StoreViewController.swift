//
//  StoreViewController.swift
//  Baby
//
//  Created by YunTu on 2017/4/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class StoreViewController: UICollectionViewController {
    
    @IBOutlet weak var flow: UICollectionViewFlowLayout!
    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        let width = (Helpers.screanSize().width - 30) / 2
        let height = width * 648 / 400
        flow.itemSize = CGSize(width: width, height: height)
        requestStore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPush" {
            let indexPath = sender as? IndexPath
            let dic = self.dataSource[indexPath!.row] as! NSDictionary
            (segue.destination as! GoodsDetailViewController).orderInfo = dic
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let dic = dataSource[indexPath.row] as! NSDictionary
        if dic["app_default_image"] != nil && (dic["app_default_image"] as! NSObject).isKind(of: NSString.self) && (dic["app_default_image"] as! String).characters.count > 0 {
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["app_default_image"] as! String))!)
        }
        (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
        (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String) + "/天"
        (cell.viewWithTag(4) as! UILabel).text = "押金：" + (dic["deposit"] as! String)
        (cell.viewWithTag(5) as! UILabel).text = dic["region_name"] as? String
        (cell.viewWithTag(6) as! UIButton).addTarget(self, action: #selector(cancelStoreBtnDidClick(_:)), for: .touchUpInside)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailPush", sender: indexPath)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func cancelStoreBtnDidClick(_ sender: UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UICollectionViewCell.self, with: sender) as! UICollectionViewCell
        let indexPath = self.collectionView?.indexPath(for: cell)
        let dic = dataSource[indexPath!.row] as! NSDictionary
        SVProgressHUD.show()
        NetworkModel.requestGet(["act":"drop_mycarts","user_id":UserModel.share.userId,"vp":UserModel.share.password,"rec_id":dic["rec_id"] as! String]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                self.requestStore()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }
    
    func requestStore() -> Void {
        SVProgressHUD.show()
        NetworkModel.requestGet(["act":"mycarts","user_id":UserModel.share.userId,"vp":UserModel.share.password]) { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                let userInfo = (dic as! NSDictionary)["retval"] as! String
                let data = userInfo.data(using: .utf8)
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
                    self.dataSource = jsonDic
                    self.collectionView?.reloadData()
                }catch{
                    
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }

}
