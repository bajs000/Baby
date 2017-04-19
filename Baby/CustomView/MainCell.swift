//
//  MainCell.swift
//  Baby
//
//  Created by YunTu on 2017/3/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SDWebImage

class MainCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collection: UICollectionView!
    
    var indexPath:IndexPath?
    fileprivate let width = (Helpers.screanSize().width - 34) / 3
    fileprivate var imgArr:[String]?
    var orderInfo:NSDictionary?{
        didSet{
            imgArr = [String]()
            if orderInfo!["img1"] != nil && (orderInfo!["img1"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img1"] as! String).characters.count > 0 {
                imgArr!.append((orderInfo!["img1"] as! String))
            }
            if orderInfo!["img2"] != nil && (orderInfo!["img2"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img2"] as! String).characters.count > 0 {
                imgArr!.append((orderInfo!["img2"] as! String))
            }
            if orderInfo!["img3"] != nil && (orderInfo!["img3"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img3"] as! String).characters.count > 0 {
                imgArr!.append((orderInfo!["img3"] as! String))
            }
            if orderInfo!["img4"] != nil && (orderInfo!["img4"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img4"] as! String).characters.count > 0 {
                imgArr!.append((orderInfo!["img4"] as! String))
            }
            if orderInfo!["img5"] != nil && (orderInfo!["img5"] as! NSObject).isKind(of: NSString.self) && (orderInfo!["img5"] as! String).characters.count > 0 {
                imgArr!.append((orderInfo!["img5"] as! String))
            }
            if imgArr!.count > 3 {
                self.collectionViewHeight.constant = 2 * width + 10
            }else{
                self.collectionViewHeight.constant = width
            }
            self.collection.reloadData()
        }
    }
    
//    {
//        didSet{
//            if (indexPath?.section)! % 2 == 0 {
//                self.collectionViewHeight.constant = width
//                self.collection.backgroundColor = #colorLiteral(red: 0.1557796597, green: 0.7823547721, blue: 0.9823170304, alpha: 1)
//            }else {
//                self.collectionViewHeight.constant = 2 * width
//                self.collection.backgroundColor = #colorLiteral(red: 0.9915902019, green: 0.2865914404, blue: 0.2129271328, alpha: 1)
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collection.delegate = self
        self.collection.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imgArr == nil {
            return 0
        }
        return imgArr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + imgArr![indexPath.row])!)
        return cell
    }
    
}
