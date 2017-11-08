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
    
    fileprivate var items = ["Jazz Concert", "Porsche Design", "", "", "", "", ""]
    
    //MARK: LIFE CYCLE
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.loadConfig()
    }
    
    //MARK: UI CONFIG
    fileprivate func loadConfig()
    {
        self.selectionStyle = .none
        
        //COLLECTION VIEW
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        layout.itemSize = CGSize(width: 300, height: 200)
        
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.collectionViewLayout = layout
        self.collection.register(UINib(nibName: "horizontalItem", bundle: nil), forCellWithReuseIdentifier: "horizontalItem")
    }
}

//MARK: COLLECTION VIEW
extension CollectionCell: UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalItem", for: indexPath) as! horizontalItem
        cell.icon.image = UIImage(named: images![indexPath.row])
//        cell.icon.image = indexPath.item % 2 == 0 ? #imageLiteral(resourceName: "imgItem1") : #imageLiteral(resourceName: "imgItem2")
        cell.title.text =  self.items[indexPath.item]
        
        return cell
    }
}

