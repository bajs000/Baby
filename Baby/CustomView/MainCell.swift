//
//  MainCell.swift
//  Baby
//
//  Created by YunTu on 2017/3/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collection: UICollectionView!
    
    let width = (Helpers.screanSize().width - 34) / 3
    var indexPath:IndexPath?{
        didSet{
            if (indexPath?.section)! % 2 == 0 {
                self.collectionViewHeight.constant = width
                self.collection.backgroundColor = #colorLiteral(red: 0.1557796597, green: 0.7823547721, blue: 0.9823170304, alpha: 1)
            }else {
                self.collectionViewHeight.constant = 2 * width
                self.collection.backgroundColor = #colorLiteral(red: 0.9915902019, green: 0.2865914404, blue: 0.2129271328, alpha: 1)
            }
        }
    }
    
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
}
