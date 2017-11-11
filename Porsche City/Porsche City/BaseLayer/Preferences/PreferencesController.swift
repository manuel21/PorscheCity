//
//  PreferencesController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class PreferencesController: UIViewController
{
    //MARK: PROPERTIES & OUTLETS
    fileprivate var vcTable: PreferencesTableController!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadConfig()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
//        let orientationValue = UIInterfaceOrientation.portrait.rawValue
//        UIDevice.current.setValue(orientationValue, forKey: "orientation")
    }

    deinit
    {
        print("Deinit: PreferencesController")
    }
    
    //MARK: CONFIG
    fileprivate func loadConfig()
    {
        //title
        self.title = "Preferences"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.items?.forEach({$0.title = ""})
    }
    
    //MARK: ACTIONS
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier , id == "PreferencesTableController" {
            
            self.vcTable = segue.destination as! PreferencesTableController
        }
    }
}
