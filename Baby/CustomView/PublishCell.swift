//
//  PublishCell.swift
//  Baby
//
//  Created by YunTu on 2017/4/10.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class PublishCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var collection: UICollectionView!
    
    var vc:UIViewController?
    var imgArr:[UIImage] = [UIImage]()
    var imgUrlArr:[String] = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imgArr.count >= 5 {
            return imgArr.count
        }
        return 1 + imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.viewWithTag(2)?.isHidden = true
        if imgArr.count > indexPath.row {
            cell.viewWithTag(2)?.isHidden = false
            (cell.viewWithTag(1) as! UIImageView).image = imgArr[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imgArr.count == indexPath.row {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            sheet.addAction(UIAlertAction(title: "相机", style: .default, handler: { (action) in
                imgPicker.sourceType = UIImagePickerControllerSourceType.camera
                self.vc?.present(imgPicker, animated: true, completion: nil)
            }))
            sheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
                imgPicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.vc?.present(imgPicker, animated: true, completion: nil)
            }))
            sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            vc?.present(sheet, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerController delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        vc?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgArr.append(img)
        (vc as! PublishGoodsViewController).imgArr = imgArr
        self.collection.reloadData()
        vc?.dismiss(animated: true, completion: nil)
        
        if imgArr.count >= 3 {
            (vc as! PublishGoodsViewController).tableView.beginUpdates()
            self.collectionHeight.constant = 99 * 2 + 10
            (vc as! PublishGoodsViewController).tableView.endUpdates()
        }
        
        UploadNetwork.request(["act":"up_laod_api","user_id":UserModel.share.userId,"vp":UserModel.share.password], data: img, paramName: "image") { (dic) in
            if Int((dic as! NSDictionary)["msg"] as! String) == 1 {
                SVProgressHUD.dismiss()
                print(dic)
                self.imgUrlArr.append((dic as! NSDictionary)["retval"] as! String)
                (self.vc as! PublishGoodsViewController).imgUrlArr = self.imgUrlArr
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["retval"] as! String)
            }
        }
    }

}
