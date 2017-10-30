//
//  ItineraryController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class ItineraryController: UIViewController
{
    //MARK: PROPERTIES & OUTLETS
    fileprivate var vcTable: ItineraryTableController!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadConfig()
    }
    
    //MARK: CONFIG
    fileprivate func loadConfig()
    {
        //title
        self.title = "Dine & Stay"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: ACTIONS
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier , id == "ItineraryTableController" {
            
            self.vcTable = segue.destination as! ItineraryTableController
        }
    }
}
