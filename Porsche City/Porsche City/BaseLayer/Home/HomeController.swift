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
    fileprivate var vcLandscape: LandscapeNavViewController!
    
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
        
        //Config for Landscape mode
        NotificationCenter.default.addObserver(self, selector: #selector(HomeController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let vcLandscapeScreen:LandscapeNavViewController = Storyboard.getInstanceFromStoryboard("Main")
        self.vcLandscape = vcLandscapeScreen
        self.vcLandscape.OnDidMoveFromLandscape = { stage in
            
            self.showModal(stage)
        }
        
    }
    
    //MARK: ACTIONS
    @objc func showProfile()
    {
        let vcProfile = Storyboard.getInstanceOf(ProfileController.self)
        let navBar = NavyController(rootViewController: vcProfile)
        self.present(navBar, animated: true, completion: nil)
    }
    @objc func rotated()
    {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            print("Landscape")            
            self.navigationController?.present(vcLandscape, animated: true, completion: nil)
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            print("Portrait")
        }
    }
    
    fileprivate func showModal(_ stage: Int)
    {
        if stage > 1 && stage <= 4
        {
            let vcParking: ValetParkingController = Storyboard.getInstanceFromStoryboard("Modals")
            self.present(vcParking, animated: true, completion: nil)
        }
        else if stage == 5
        {
            let vcHotelCheckin: HotelCheckInController = Storyboard.getInstanceFromStoryboard("Modals")
            self.present(vcHotelCheckin, animated: true, completion: nil)
        }
        else if stage == 6
        {
            let vcRide: RideController = Storyboard.getInstanceFromStoryboard("Modals")
            self.present(vcRide, animated: true, completion: nil)
        }
        else if stage == 7
        {
            let vcRoomKey: RoomKeyController = Storyboard.getInstanceFromStoryboard("Modals")
            self.present(vcRoomKey, animated: true, completion: nil)
        }
        else if stage == 8
        {
            
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier , id == "HomeTableController" {
            
            self.vcTable = segue.destination as! HomeTableController
        }
    }
    
}
