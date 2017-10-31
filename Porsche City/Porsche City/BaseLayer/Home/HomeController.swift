//
//  HomeController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class HomeController: UIViewController
{
    //MARK: PROPERTIES & OUTLETS
    fileprivate var vcTable: HomeTableController!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadConfig()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.gestureRecognizers?.removeAll()
        self.navigationController?.navigationBar.addGestureRecognizer(ActionsTapGestureRecognizer(onTap: {
            
            let vcSelection = Storyboard.getInstanceOf(CitySelectionController.self)
            let navBar = NavyController(rootViewController: vcSelection)
            
            self.present(navBar, animated: true, completion: nil)
        }))
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.gestureRecognizers?.removeAll()
    }

    deinit
    {
        print("Deinit: HomeTableController")
    }
    
    //MARK: CONFIG
    fileprivate func loadConfig()
    {
        //title
        self.title = "Beverly Hills"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //Left Button
        let BtnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        BtnProfile.setImage(#imageLiteral(resourceName: "iconUserProfile"), for: .normal)
        BtnProfile.contentMode = .scaleAspectFit
        BtnProfile.addTarget(self, action: #selector(self.showProfile), for: .touchUpInside)
        
        let barBtnProfile = UIBarButtonItem(customView: BtnProfile)
        let widthConstraint = BtnProfile.widthAnchor.constraint(equalToConstant: 32)
        let heightConstraint = BtnProfile.heightAnchor.constraint(equalToConstant: 32)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  barBtnProfile
    }
    
    //MARK: ACTIONS
    @objc func showProfile()
    {
        let vcProfile = Storyboard.getInstanceOf(ProfileController.self)
        let navBar = NavyController(rootViewController: vcProfile)
        
        self.present(navBar, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier , id == "HomeTableController" {
            
            self.vcTable = segue.destination as! HomeTableController
        }
    }
}
