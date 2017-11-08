//
//  Timer.swift
//  NavigationCollectionView
//
//  Created by Nestor Javier Hernandez Bautista on 10/31/17.
//  Copyright © 2017 com.me. All rights reserved.
//

import UIKit

class TimerStep: NSObject
{
    var timer:Timer?
    var journeyStages:Int = 5
    var timeStep:TimeInterval!
    var counter = 1
    var isTraveling = false
    var timeInterval:TimeInterval = 0
    //Closures
    var OnJourneyStarted:((_ stage:Int)->())?
    var OnJourneyPaused:((_ stage:Int)->())?
    var OnMoveStage:((_ stage:Int)->())?
    var OnJourneyWillEnd:(()->())?
    var OnJourneyDidEnded:(()->())?
    
    override init()
    {
        self.timeStep = 5.0
    }
    
    convenience init(journeyStages:Int, timeStep: TimeInterval)
    {
        self.init()
        self.timeStep = timeStep
        self.journeyStages = journeyStages
    }
    
    public func startJourney()
    {
        self.isTraveling = true
        self.OnJourneyStarted?(self.counter)
        if timer == nil
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerStep.checkTimeInterval), userInfo: nil, repeats: true)
        }        
    }
    
    public func pauseJourney()
    {
        guard self.timer != nil else {return}
        self.timer?.invalidate()
        self.timer = nil
        self.OnJourneyPaused?(self.counter)
    }
    
    public func stopJourney()
    {
        guard self.timer != nil else {return}
        self.timer?.invalidate()
        self.timer = nil
        self.isTraveling = false
        self.timeInterval = 0
        self.counter = 1
        self.OnJourneyDidEnded?()
    }
    
    @objc private func checkTimeInterval()
    {
        print("Time interval: \(self.timeInterval)")
        self.timeInterval += 1
        if self.timeInterval == self.timeStep
        {
            self.timeInterval = 0
            self.tripAssesment()
        }
    }
    
    @objc private func tripAssesment()
    {
        self.counter += 1;
        
        guard self.counter != self.journeyStages else {
            
            self.stopJourney()
            return
        }
        
        self.OnMoveStage?(counter)
        if self.journeyStages - 1 == 0
        {
            self.OnJourneyWillEnd?()
        }
    }
}
