//
//  LandscapeNavViewController.swift
//  Porsche City
//
//  Created by Nestor Javier Hernandez Bautista on 11/1/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class LandscapeNavViewController: UIViewController
{
    //MARK: Variables and outlets
    
    //Bottom Navigation Menu
    var imgsJourney = [UIImage]()
    var imgsBottomNav = [UIImage]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgBackground: UIImageView!
    let defaultBackground = UIColor(displayP3Red: 25/255, green: 31/255, blue: 34/255, alpha: 1.0)
    var origin:CGFloat = 0.0
    var initialNavBarHeight:CGFloat = 0.0
    var StageIdx: Int = 0 {
        didSet{
            self.UpdateScreen()
            self.HideBottomNavBar()
            self.collectionView.scrollToItem(at: IndexPath(item: StageIdx, section: 0), at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
    }
    @IBOutlet weak var lblTitle: UIView!    
    @IBOutlet weak var lblTitleDown: UIView!
    
    //Callbacks
    var OnDidMoveFromLandscape:((_ stage: Int)->())?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadConfig()
    }

    //MARK: CONFIGURATION
    fileprivate func loadConfig()
    {
        //Collection view
        self.collectionView.delegate = self
        
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(LandscapeNavViewController.OnRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //Set gesture recognizers
        self.imgBackground.isUserInteractionEnabled = true
        self.imgBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.OnMainScreenPressed)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.moveLeft))
        swipeLeft.direction = .left
        self.imgBackground.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.moveRight))
        swipeRight.direction = .right
        self.imgBackground.addGestureRecognizer(swipeRight)
        //Journey images
        var imgTitles = ["imgJ0","imgJ1","imgJ2","imgJ3","imgJ4","imgJ5","imgJ6","imgJ7","imgJ8"]
        imgTitles.forEach { (title) in
            self.imgsJourney.append(UIImage(named:title) ?? UIImage())
        }
        imgTitles = ["imgDefaultBackground","imgJ1","imgDefaultBackground","imgDefaultBackground","imgJ4","imgDefaultBackground","imgDefaultBackground","imgJ7","imgDefaultBackground"]
        imgTitles.forEach { (title) in
            self.imgsBottomNav.append(UIImage(named:title) ?? UIImage())
        }
        //UI measures
        self.origin = self.collectionView.frame.origin.y
        self.initialNavBarHeight = self.collectionView.frame.height
        //Hide nav bar
        self.HideBottomNavBar()
    }
    //MARK: ACTIONS
    @objc func OnMainScreenPressed()
    {
        if(self.collectionView.alpha == 1.0)
        {
            self.HideBottomNavBar()
        }
        else
        {
            self.ShowBottomNavBar()
        }
    }
    
    @objc func moveLeft()
    {
        guard StageIdx < self.imgsJourney.count - 1 else {return}
        self.StageIdx += 1
    }
    @objc func moveRight()
    {
        guard StageIdx > 0 else {return}
        self.StageIdx -= 1
        self.collectionView.selectItem(at: IndexPath(item: self.StageIdx, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    fileprivate func HideBottomNavBar()
    {
        UIView.animate(withDuration: 0.4) {
            
            self.collectionView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            self.lblTitle.alpha = 0.0
            self.lblTitleDown.alpha = 1.0
            self.collectionView.alpha = 0.0
        }
    }
    
    fileprivate func ShowBottomNavBar()
    {
        self.collectionView.scrollToItem(at: IndexPath(item: StageIdx, section: 0), at: .centeredHorizontally, animated: true)
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1.0
            self.lblTitle.alpha = 1.0
            self.lblTitleDown.alpha = 0.0
            self.collectionView.frame.origin = CGPoint(x: 0, y: self.origin)
        }
    }
    
    @objc func OnRotation()
    {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            print("Landscape")
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            print("Portrait")
            dismiss(animated: true, completion: {
                self.HideBottomNavBar()
                self.OnDidMoveFromLandscape?(self.StageIdx)
            })
        }
    }
    
    fileprivate func UpdateScreen()
    {
        self.imgBackground.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            
            self.imgBackground.image = self.imgsJourney[self.StageIdx]
            self.imgBackground.alpha = 1.0
        }
        
        //UI particular updates
        self.lblTitle.isHidden = StageIdx == 0 ? false : true
        self.lblTitleDown.isHidden = StageIdx == 0 ? false : true
    }
}

extension LandscapeNavViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imgsBottomNav.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? JourneyCell
        cell?.imgPlace.image = self.imgsBottomNav[indexPath.row]
        cell?.viewBackground.backgroundColor = StageIdx == indexPath.row ? .red : self.defaultBackground
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.StageIdx = indexPath.row
        self.collectionView.reloadData()
    }
}
