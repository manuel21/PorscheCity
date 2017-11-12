//
//  HotelCheckInController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class HotelCheckInController: UIViewController
{
    //MARK: PROPERTIES & OUTLETS
    @IBOutlet weak fileprivate var collection: UICollectionView!
    fileprivate var items = ["Luggage Delivery", "Spa Package"]
    fileprivate static let firstItem = "item5"
    fileprivate static let secondItem = "imgItem4"
    fileprivate var images = [firstItem + "_unchecked", "spaPackage"]
    fileprivate var firstChecked = false
    fileprivate var secondChecked = false
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadConfig()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
//        let orientationValue = UIInterfaceOrientation.portrait.rawValue
//        UIDevice.current.setValue(orientationValue, forKey: "orientation")
    }
    
    deinit
    {
        print("Deinit: HotelCheckInController")
    }
    
    //MARK: CONFIG
    fileprivate func loadConfig()
    {
        //COLLECTION VIEW
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        layout.itemSize = CGSize(width:  300, height: 200)
        
        self.collection.collectionViewLayout = layout
        self.collection.register(UINib(nibName: "horizontalItem", bundle: nil), forCellWithReuseIdentifier: "horizontalItem")
    }
    
    //MARK: ACTIONS
    @IBAction func close()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

//MARK: COLLECTION VIEW
extension HotelCheckInController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalItem", for: indexPath) as! horizontalItem
        cell.icon.image = UIImage(named: self.images[indexPath.item])
        cell.title.text = self.items[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.row == 0
        {
            firstChecked = !firstChecked
            if firstChecked {
                (UIApplication.shared.delegate as? AppDelegate)?.scheduleNotification(type: .hotelCheckIn)
            }
            
            images[0] = HotelCheckInController.firstItem + (firstChecked ? "" : "_unchecked")
            collectionView.reloadItems(at: [indexPath])
        }
            /*
        else {
            secondChecked = !secondChecked
            images[1] = HotelCheckInController.secondItem + (secondChecked ? "" : "_unchecked")
            collectionView.reloadItems(at: [indexPath])
        }
 */
    }
}

