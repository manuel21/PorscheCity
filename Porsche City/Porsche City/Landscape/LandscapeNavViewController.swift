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
    
    //FLOW
    var onChangeFlow:((_ flow:Int)->())?    
    @IBOutlet weak var imgPerson1: UIImageView!
    @IBOutlet weak var imgPerson2: UIImageView!
    var flow = 1 {
        didSet{
            self.imgsJourney.removeAll()
            self.imgsBottomNav.removeAll()
            self.onChangeFlow?(flow)
            if flow == 1
            {
                //Journey images
                var imgTitles = ["imgJ0","imgJ1","imgJ2","imgJ3","imgJ4","imgJ5","imgJ6","imgJ7","imgJ8"]
                imgTitles.forEach { (title) in
                    self.imgsJourney.append(UIImage(named:title) ?? UIImage())
                }
                imgTitles = ["imgJ0","imgJ1","imgJ2","imgJ3","imgJ4","imgJ5","imgJ6","imgJ7","imgJ8"]
                imgTitles.forEach { (title) in
                    self.imgsBottomNav.append(UIImage(named:title) ?? UIImage())
                }
            }
            else
            {
                //Journey images
                var imgTitles = ["imgJ0","imgJ1","imgJ2_flow2","imgJ3_flow2","imgJ4_flow2","imgJ5_flow2","imgJ6_flow2"]
                imgTitles.forEach { (title) in
                    self.imgsJourney.append(UIImage(named:title) ?? UIImage())
                }
                
                imgTitles = ["imgJ0","imgJ1","imgJ2_flow2","imgJ3_flow2","imgJ4_flow2","imgJ5_flow2","imgJ6_flow2"]
                imgTitles.forEach { (title) in
                    self.imgsBottomNav.append(UIImage(named:title) ?? UIImage())
                }
            }
            self.collectionView.reloadData()
        }
    }
    
    
    
    
    //Bottom Navigation Menu
    var imgsJourney = [UIImage]()
    var imgsBottomNav = [UIImage]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewBackground: UICollectionView!
    
    @IBOutlet weak var imgBackground: UIImageView!
    let defaultBackground = UIColor(displayP3Red: 25/255, green: 31/255, blue: 34/255, alpha: 1.0)
    var origin:CGFloat = 0.0
    var initialNavBarHeight:CGFloat = 0.0
    var manualMode = true
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
            
            if flow == 1
            {
                if StageIdx == 0
                {
                    self.journeyTimer?.stopJourney()
                    self.stepCounter?.stopsMotionTimer()
                }
                else if StageIdx == 1
                {
                    //Send notification
                    (UIApplication.shared.delegate as? AppDelegate)?.scheduleNotification(type: .restaurantHost)
                    
                    guard self.manualMode == false else {return}
                    
                    //Starts journey
                    if self.journeyBySeconds == true
                    {
                        if self.journeyTimer?.isTraveling == false
                        {
                            self.journeyTimer?.startJourney()
                        }
                    }
                    else
                    {
                        self.stepCounter?.initPedometer()
                    }
                    
                }
                else if StageIdx == 2
                {
                    (UIApplication.shared.delegate as? AppDelegate)?.scheduleNotification(type: .restaurantValet)
                }
                else if StageIdx == 6
                {
                    (UIApplication.shared.delegate as? AppDelegate)?.scheduleNotification(type: .shuttleDriver)
                }
                else if StageIdx == 8
                {
                    self.stepCounter?.stopsMotionTimer()
                }
                
            }
            else if flow == 2
            {
                if StageIdx == 0
                {
                    self.journeyTimer?.stopJourney()
                    self.stepCounter?.stopsMotionTimer()
                }
                else if StageIdx == 1
                {
                    guard self.manualMode == false else {return}
                    
                    //Starts journey
                    if self.journeyBySeconds == true
                    {
                        if self.journeyTimer?.isTraveling == false
                        {
                            self.journeyTimer?.startJourney()
                        }
                    }
                    else
                    {
                        self.stepCounter?.initPedometer()
                    }
                }
            }
            
        }
    }
    @IBOutlet weak var lblTitleDown: UIView!
    
    //Movement    
    @IBOutlet weak var lblSteps: UILabel!
    
    //Journey timer
    var journeyTimer:TimerStep?
    
    //Step counter
    var stepCounter: StepCounter?
    
    //Callbacks
    var OnDidMoveFromLandscape:((_ stage: Int)->())?
    
    //Config
    var journeyBySeconds = true
    var vcConfig: ConfigurationController?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadConfig()
        self.configureTimer()
        self.configureStepCounter()
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
        self.collectionViewBackground.delegate = self
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(LandscapeNavViewController.OnRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //Set gesture recognizers
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.moveLeft))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.moveRight))
        let tapOnPerson1 = UITapGestureRecognizer(target: self, action: #selector(self.didChooseFlow1))
        let tapOnPerson2 = UITapGestureRecognizer(target: self, action: #selector(self.didChooseFlow2))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        self.imgBackground.isUserInteractionEnabled = true
        self.imgBackground.addGestureRecognizer(swipeLeft)
        self.imgBackground.addGestureRecognizer(swipeRight)
        self.imgPerson1.isUserInteractionEnabled = true
        self.imgPerson2.isUserInteractionEnabled = true
        self.imgPerson1.addGestureRecognizer(tapOnPerson1)
        self.imgPerson2.addGestureRecognizer(tapOnPerson2)
        self.imgPerson1.isHidden = true
        self.imgPerson2.isHidden = true
        
        self.collectionViewBackground.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.OnPinchScreen(_: ))))
        self.collectionViewBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.OnMainScreenPressed)))
        
        //Journey images
        var imgTitles = ["imgJ0","imgJ1","imgJ2","imgJ3","imgJ4","imgJ5","imgJ6","imgJ7","imgJ8"]
        imgTitles.forEach { (title) in
            self.imgsJourney.append(UIImage(named:title) ?? UIImage())
        }
        imgTitles = ["imgJ0","imgJ1","imgJ2","imgJ3","imgJ4","imgJ5","imgJ6","imgJ7","imgJ8"]
        imgTitles.forEach { (title) in
            self.imgsBottomNav.append(UIImage(named:title) ?? UIImage())
        }
        //UI measures
        self.origin = self.collectionView.frame.origin.y
        self.initialNavBarHeight = self.collectionView.frame.height
        
        //Configuration Control
        self.vcConfig = Storyboard.getInstanceFromStoryboard("Main")
        self.vcConfig?.onSetConfiguration = { seconds, steps in
            self.manualMode = false
            self.journeyTimer?.timeStep = Double(seconds)
            self.stepCounter?.numberOfSteps = steps
        }
        self.vcConfig?.onCancel = {
            
            self.manualMode = true
        }
        self.vcConfig?.onJourneyByTime = { journeyByTime in
            
            self.journeyBySeconds = journeyByTime
        }
        self.vcConfig?.onChangeFlow = { flow in
            
            self.flow = flow
        }
        //Hide steps
        self.lblSteps.isHidden = true
        
        //Hide nav bar
        self.HideBottomNavBar()
    }
    
    fileprivate func configureStepCounter()
    {
        self.stepCounter = StepCounter(numberOfSteps: 10)
        self.stepCounter?.onDidCoverDistance = { stage in
        
            self.StageIdx = stage
        }
        
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
        self.journeyTimer?.OnJourneyDidEnded = { 
            
            print("Journey stoped")
        }
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
    
    @objc func OnPinchScreen(_ sender: UIPinchGestureRecognizer)
    {
        guard  self.StageIdx == 0 else {
            
            return 
        }
        if sender.state == .began
        {
            self.present(self.vcConfig!, animated: true, completion: nil)
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
    @objc func didChooseFlow1()
    {
        self.imgPerson1.image = UIImage(named:"Richard_selected")
        self.imgPerson2.image = UIImage(named:"Taylor_unselected")
        self.flow = 1
        self.StageIdx = 0
        self.manualMode = true
        self.configureTimer()
        
    }
    @objc func didChooseFlow2()
    {
        self.imgPerson2.image = UIImage(named:"Taylor_selected")
        self.imgPerson1.image = UIImage(named:"Richard_unselected")
        self.flow = 2
        self.StageIdx = 0
        self.manualMode = true
        self.configureTimer()
    }
    
    fileprivate func HideBottomNavBar()
    {
        if StageIdx != 0 && self.manualMode == false && self.journeyTimer?.isTraveling == true
        {
            self.journeyTimer?.startJourney()
        }
        
        //Update screen
        UIView.animate(withDuration: 0.4) {
            
            self.collectionView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            self.collectionView.alpha = 0.0
            self.lblTitleDown.alpha = 1.0
            self.imgPerson1.isHidden = true
            self.imgPerson2.isHidden = true
            self.imgBackground.alpha = 1.0
        }
    }
    
    fileprivate func ShowBottomNavBar()
    {
        self.journeyTimer?.pauseJourney()
        //Update screen
        self.collectionView.scrollToItem(at: IndexPath(item: StageIdx, section: 0), at: .centeredHorizontally, animated: true)
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1.0
            self.collectionView.frame.origin = CGPoint(x: 0, y: self.origin)
            self.lblTitleDown.alpha = 0.0
            self.imgPerson1.isHidden = false
            self.imgPerson2.isHidden = false
            self.imgBackground.alpha = 0.5
        }
    }
    
    @objc func OnRotation()
    {
        if Utils.isLandscape()
        {
            print("Landscape")
        }
        
        if Utils.isPortrait()
        {
            print("Portrait")
            self.journeyTimer?.pauseJourney()
            dismiss(animated: true, completion: {
                
                //Hide navigation bar
                UIView.animate(withDuration: 0.4) {
                    
                    self.collectionView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
                    self.collectionView.alpha = 0.0
                    self.lblTitleDown.alpha = 1.0
                    self.imgPerson1.isHidden = true
                    self.imgPerson2.isHidden = true
                    self.imgBackground.alpha = 1.0
                }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
            if collectionView.tag == 1
            {
                print(indexPath.row)
            }
    }
}

//extension LandscapeNavViewController: UIGestureRecognizerDelegate
//{
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
//    {
//        guard  self.StageIdx == 0 else {
//
//            return false
//        }
//        self.present(self.vcConfig!, animated: true, completion: nil)
//        return true
//    }
//}

