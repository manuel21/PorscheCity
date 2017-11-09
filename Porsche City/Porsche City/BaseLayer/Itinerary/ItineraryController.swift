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
    var onBellTapped: (() -> ())?
    
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
        print("Deinit: ItineraryController")
    }
    
    //MARK: CONFIG
    fileprivate func loadConfig()
    {
        //title
        self.title = "Dine & Stay"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if onBellTapped != nil {
            //Right Button
            let BtnBell = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            BtnBell.setImage(#imageLiteral(resourceName: "iconBell"), for: .normal)
            BtnBell.contentMode = .scaleAspectFit
            BtnBell.addTarget(self, action: #selector(self.openSomething), for: .touchUpInside)

            let barBtnBell = UIBarButtonItem(customView: BtnBell)
            let widthConstraintRight = BtnBell.widthAnchor.constraint(equalToConstant: 50)
            let heightConstraintRight = BtnBell.heightAnchor.constraint(equalToConstant: 50)
            heightConstraintRight.isActive = true
            widthConstraintRight.isActive = true

            navigationItem.rightBarButtonItem = barBtnBell
        }
    }
    
    //MARK: ACTIONS
    @objc func openSomething()
    {
        onBellTapped?()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier , id == "ItineraryTableController" {
            
            self.vcTable = segue.destination as! ItineraryTableController
        }
    }
}
