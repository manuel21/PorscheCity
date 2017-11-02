//
//  StepCounter.swift
//  Porsche City
//
//  Created by Nestor Javier Hernandez Bautista on 11/2/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit
import CoreMotion

class StepCounter
{
    var pedometer = CMPedometer()
    var pedometerData = CMPedometerData()
    var motionTimer = Timer()
    var numberOfSteps = 10
    var stepCounter = 0
    var stageCounter = 1
    var onDidCoverDistance:((_ stage: Int)->())?
    
    init()
    {
        self.numberOfSteps = 10
    }
    
    convenience init(numberOfSteps:Int)
    {
        self.init()
        self.numberOfSteps = 10
    }
    
    func initPedometer()
    {
        if CMPedometer.isStepCountingAvailable() == true
        {
            print("Movement sensor available")
            self.startMotionTimer()
            self.pedometer.startUpdates(from: Date(), withHandler: { (data, error) in
                if let pedometerData = data {
                    
                    self.stepCounter = Int(truncating: pedometerData.numberOfSteps)
                    print("steps \(self.stepCounter)")
                }
                else
                {
                    self.stopsMotionTimer()
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
                
                guard self.stepCounter != 0 else {return}
                var counter = self.stepCounter / self.numberOfSteps
                
                if counter >= self.stageCounter
                {
                    self.stageCounter += 1
                    self.onDidCoverDistance?(self.stageCounter)
                }                
            })
        }
    }
    
    func stopsMotionTimer()
    {
        self.stepCounter = 0
        self.stageCounter = 1
        self.motionTimer.invalidate()
        self.pedometer.stopUpdates()
    }
}
