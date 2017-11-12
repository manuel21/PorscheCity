//
//  TimelineUpdatedCell.swift
//  BCM
//
//  Created by Manuel Salinas on 9/1/17.
//  Copyright © 2017 Nestor Javier Hernandez Bautista. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell
{    
    //MARK: OUTLETS AND VARIABLES
    @IBOutlet weak fileprivate var collection: UICollectionView!
    var images: [String]?
    var items = [String]()
    var cellHeight: CGFloat = 200
    var cellWidth: CGFloat = 300
    var adoptCollectionViewHeight = false
    var imageContentMode: UIViewContentMode?
    
    //MARK: LIFE CYCLE
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.loadConfig()
    }
    
    //MARK: UI CONFIG
    fileprivate func loadConfig()
    {
        self.collection.register(UINib(nibName: "horizontalItem", bundle: nil), forCellWithReuseIdentifier: "horizontalItem")
        self.collection.delegate = self
        self.collection.dataSource = self
        
        self.selectionStyle = .none
        
        //COLLECTION VIEW
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        layout.itemSize = CGSize(width: cellWidth, height: adoptCollectionViewHeight ? collection.frame.height : cellHeight)
        
        self.collection.collectionViewLayout = layout
    }
    
    func reloadCollection()
    {
        self.collection.reloadData()
    }
}

//MARK: COLLECTION VIEW
extension CollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: adoptCollectionViewHeight ? collection.frame.height : cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalItem", for: indexPath) as! horizontalItem
        if imageContentMode != nil {
            cell.icon.contentMode = contentMode
        }
        cell.icon.image = UIImage(named: images![indexPath.row])
        cell.title.text =  self.items[indexPath.item]
        
        return cell
    }
}

