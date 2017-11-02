//
//  LandscapeNavViewController.swift
//  Porsche City
//
//  Created by Nestor Javier Hernandez Bautista on 11/1/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit
import CoreMotion

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
            guard StageIdx < self.imgsJourney.count else {
                
                self.StageIdx = self.imgsJourney.count - 1
                return
            }
            
            self.UpdateScreen()
            self.HideBottomNavBar()
            self.collectionView.scrollToItem(at: IndexPath(item: StageIdx, section: 0), at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
            
            if StageIdx == 1
            {
                (UIApplication.shared.delegate as? AppDelegate)?.createNotification(type: .restaurantHost)
            }
            else if StageIdx == 2
            {
                (UIApplication.shared.delegate as? AppDelegate)?.createNotification(type: .restaurantValet)
            }
            else if StageIdx == 6
            {
                (UIApplication.shared.delegate as? AppDelegate)?.createNotification(type: .shuttleDriver)
            }
        }
    }
    @IBOutlet weak var lblTitle: UIView!    
    @IBOutlet weak var lblTitleDown: UIView!
    
    //Movement
    var pedometer = CMPedometer()
    var pedometerData = CMPedometerData()
    var motionTimer = Timer()
    var numberOfSteps = 0
    @IBOutlet weak var lblSteps: UILabel!
    
    //Journey timer
    var journeyTimer:TimerStep?
    //Callbacks
    var OnDidMoveFromLandscape:((_ stage: Int)->())?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadConfig()
        self.configureTimer()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        if self.journeyTimer?.isTraveling == true
        {
            self.journeyTimer?.startJourney()
        }
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
    
    fileprivate func configureTimer()
    {
        //Create timer
        self.journeyTimer = TimerStep(journeyStages:self.imgsJourney.count, timeStep: 3)
        self.journeyTimer?.OnJourneyStarted = { stage in
            
            print("Journey started at stage: \(stage)")
        }
        self.journeyTimer?.OnJourneyPaused = { stage in
            
            print("Journey paused at stage: \(stage)")
        }
        self.journeyTimer?.OnMoveStage = { stage in
            print(stage)
            self.StageIdx = stage
        }
    }
    
    func initPedometer()
    {
        self.lblSteps.text = "Steps: Not available";
        if CMPedometer.isStepCountingAvailable() == true
        {
            self.startMotionTimer()
            pedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                if let pedometerData = data {
                    print("Pull data")
                    self.numberOfSteps = Int(pedometerData.numberOfSteps)
                }
                else
                {
                    self.stopsMotionTimer()
                    self.lblSteps.text = "Not available"
                }
            })
        }
    }
    func startMotionTimer()
    {
        print("Started motion timer")
        if motionTimer.isValid == false
        {
            motionTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
                self.displayPedometerData()
            })
        }
    }
    func stopsMotionTimer()
    {
        self.motionTimer.invalidate()
        self.displayPedometerData()
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
            self.journeyTimer?.pauseJourney()
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
    
    func displayPedometerData()
    {
        lblSteps.text = "Steps: \(numberOfSteps)"
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
        if self.StageIdx == 1
        {
            self.initPedometer()
            if self.journeyTimer?.isTraveling == false
            {
                self.journeyTimer?.startJourney()
            }
        }
        
    }
}
