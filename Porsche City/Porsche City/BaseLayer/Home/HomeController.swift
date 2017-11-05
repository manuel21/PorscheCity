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
    fileprivate var wasOnceOnLandscape = false
    
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
        var imgProfile: UIImage = #imageLiteral(resourceName: "Richard")
        let height = (imgProfile.cgImage?.height ?? 50) / 2
        imgProfile = maskRoundedImage(image: imgProfile, radius: CGFloat(height))
        
        BtnProfile.setImage(imgProfile, for: .normal)
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
        
        let vcLandscapeScreen = Storyboard.getInstanceOf(LandscapeNavViewController.self)
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
    
    @objc func openSomething()
    {
        showModal(vcLandscape.StageIdx)
    }
    
    @objc func rotated()
    {
        if Utils.isLandscape()
        {
            print("Landscape")
            if presentedViewController is LandscapeNavViewController {
                return
            }
            
//            if self.presentedViewController != nil {return}
            if self.presentedViewController != nil {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
            
            self.navigationController?.present(vcLandscape, animated: true, completion: nil)
            self.wasOnceOnLandscape = true
        }
        
        if Utils.isPortrait()
        {
            print("Portrait")
           
            if self.wasOnceOnLandscape == true
            {
                //Right Button
                if (vcLandscape.StageIdx > 1) {
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
                } else {
                    navigationItem.rightBarButtonItem = nil
                }
            }
        }
    }
    
    fileprivate func showModal(_ stage: Int)
    {
        if stage == 0
        {
            self.vcTable.stageIdx = stage
        }
        else if stage == stage
        {
            self.vcTable.stageIdx = 1
        }
        else if stage > 1 && stage <= 4
        {
            if presentedViewController is ValetParkingController {return}
            
            let vcParking: ValetParkingController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
            self.present(vcParking, animated: true, completion: nil)
        }
        else if stage == 5
        {
            if presentedViewController is HotelCheckInController {return}
            
            let vcHotelCheckin: HotelCheckInController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
            self.present(vcHotelCheckin, animated: true, completion: nil)
        }
        else if stage == 6
        {
            if presentedViewController is RideController {return}
            
            let vcRide: RideController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
            self.present(vcRide, animated: true, completion: nil)
        }
        else if stage == 7
        {
            if presentedViewController is RoomKeyController {return}
            
            let vcRoomKey: RoomKeyController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
            self.present(vcRoomKey, animated: true, completion: nil)
        }
        else if stage == 8
        {
            if presentedViewController is CheckoutController {return}
            
            let vcCheckout: CheckoutController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
            vcCheckout.onDeinit = {
                
                let vcCheckoutSuccess: CheckoutSuccessController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                self.present(vcCheckoutSuccess, animated: true, completion: nil)
            }
            
            self.present(vcCheckout, animated: true, completion: nil)
        }
    }
    func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier , id == "HomeTableController" {
            
            self.vcTable = segue.destination as! HomeTableController
        }
    }
    
}
