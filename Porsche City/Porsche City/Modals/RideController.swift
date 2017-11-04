//
//  RideController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class RideController: UIViewController
{
    //MARK: PROPERTIES & OUTLETS
    
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
        print("Deinit: RideController")
    }
    
    //MARK: CONFIG
    fileprivate func loadConfig()
    {
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
