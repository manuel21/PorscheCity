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
    @IBOutlet weak var viewPersons: UIView!
    @IBOutlet weak var imgPerson1: UIImageView!
    @IBOutlet weak var imgPerson2: UIImageView!
    var flow = 1 {
        didSet{
            self.onChangeFlow?(flow)
            setImages(images:
                flow == 1 ? ["imgJ0","imgJ1","imgJ2","imgJ3","imgJ4","imgJ5","imgJ6","imgJ7","imgJ8"]
                : ["imgJ1","imgJ2_flow2","imgJ3_flow2","imgJ4_flow2","imgJ5_flow2","imgJ6_flow2"]
            )
            
            self.collectionView.reloadData()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.flow = flow
        }
    }
    
    
    //Bottom Navigation Menu
    var imgsJourney = [UIImage]()
    var imgsBottomNav = [UIImage]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    let defaultBackground = UIColor(displayP3Red: 25/255, green: 31/255, blue: 34/255, alpha: 1.0)
    var origin:CGFloat = 0.0
    var initialNavBarHeight:CGFloat = 0.0
    var manualMode = true
    var StageIdx: Int = 0
    @IBOutlet weak var lblTitleDown: UIView!
    fileprivate var isFirstLoad = true
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad {
            isFirstLoad = false
            
            //Journey images
            setImages(images: ["imgJ0","imgJ1","imgJ2","imgJ3","imgJ4","imgJ5","imgJ6","imgJ7","imgJ8"])
        }
        
        if self.journeyTimer?.isTraveling == true
        {
            self.journeyTimer?.startJourney()
        }
        
        scrollToPage(page: StageIdx, duration: 0.1)
    }
    
    //MARK: CONFIGURATION
    fileprivate func loadConfig()
    {
        //Collection view
        self.collectionView.delegate = self
        
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(LandscapeNavViewController.OnRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let tapOnPerson1 = UITapGestureRecognizer(target: self, action: #selector(self.didChooseFlow1))
        let tapOnPerson2 = UITapGestureRecognizer(target: self, action: #selector(self.didChooseFlow2))
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.OnMainScreenPressed)))
        
        self.imgPerson1.isUserInteractionEnabled = true
        self.imgPerson2.isUserInteractionEnabled = true
        self.imgPerson1.addGestureRecognizer(tapOnPerson1)
        self.imgPerson2.addGestureRecognizer(tapOnPerson2)
        viewPersons.isHidden = true
        
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
    
    fileprivate func setImages(images: [String]) {
        self.imgsJourney.removeAll()
        self.imgsBottomNav.removeAll()
        
        for (index, title) in images.enumerated() {
            let image = UIImage(named:title) ?? UIImage()
            self.imgsJourney.append(image)
            
            let imageView = UIImageView(frame: CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
            imageView.image = image
            scrollView.addSubview(imageView)
            
            self.imgsBottomNav.append(image)
        }
        collectionView.reloadData()
        scrollView.contentSize.width = scrollView.frame.width * CGFloat(images.count)
    }
    
    fileprivate func configureStepCounter()
    {
        self.stepCounter = StepCounter(numberOfSteps: 10)
        self.stepCounter?.onDidCoverDistance = { stage in
            self.setCurrentPage(page: stage)
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
            self.setCurrentPage(page: stage)
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
    
    @objc func didChooseFlow1()
    {
        self.imgPerson1.image = UIImage(named:"Richard_selected")
        self.imgPerson2.image = UIImage(named:"Taylor_unselected")
        self.flow = 1
        setCurrentPage(page: 0)
        self.manualMode = true
        self.configureTimer()
        
    }
    @objc func didChooseFlow2()
    {
        self.imgPerson2.image = UIImage(named:"Taylor_selected")
        self.imgPerson1.image = UIImage(named:"Richard_unselected")
        self.flow = 2
        setCurrentPage(page: 0)
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
            self.viewPersons.isHidden = true
            self.scrollView.alpha = 1
        }
    }
    
    fileprivate func ShowBottomNavBar()
    {
        self.journeyTimer?.pauseJourney()
        //Update screen
        self.collectionView.scrollToItem(at: IndexPath(item: StageIdx, section: 0), at: .centeredHorizontally, animated: true)
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1.0
            self.collectionView.frame.origin = CGPoint(x: 0, y: self.view.frame.maxY - self.collectionView.frame.height)
            self.lblTitleDown.alpha = 0.0
            self.viewPersons.isHidden = false
            self.scrollView.alpha = 0.5
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
                    self.viewPersons.isHidden = true
                    self.scrollView.alpha = 1
                }
                self.OnDidMoveFromLandscape?(self.StageIdx)
            })
        }
    }
    
    fileprivate func scrollToPage(page: Int, animated: Bool = true, duration: Double = 0.3) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.scrollView.contentOffset.x = CGFloat(page) * self.scrollView.frame.width
            })
        } else {
            scrollView.contentOffset.x = CGFloat(page) * scrollView.frame.width
        }
    }
    
    fileprivate func setCurrentPage(page: Int) {
        if (page != StageIdx) {
            StageIdx = page
            
            scrollToPage(page: page)
//            collectionView.selectItem(at: IndexPath(item: self.StageIdx, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            self.collectionView.reloadData()
//            collectionView.scrollToItem(at: IndexPath(item: StageIdx, section: 0), at: .centeredHorizontally, animated: true)
            
            lblTitleDown.isHidden = StageIdx != 0
            HideBottomNavBar()
            
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
        setCurrentPage(page: indexPath.row)
    }
}

extension LandscapeNavViewController: UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if StageIdx > 0 {
            return false
        }
        
        present(self.vcConfig!, animated: true, completion: nil)
        return true
    }
}

extension LandscapeNavViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if (page != StageIdx) {
            setCurrentPage(page: page)
        }
    }
}
