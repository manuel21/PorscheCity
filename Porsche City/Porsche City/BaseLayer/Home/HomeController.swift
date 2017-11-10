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
    fileprivate final let dropDownChar = " ▾" //﹀
    
    //MARK: PROPERTIES & OUTLETS
    fileprivate var vcTable: HomeTableController!
    fileprivate var vcLandscape: LandscapeNavViewController!
    fileprivate var wasOnceOnLandscape = false
    var flow = 1
    var BtnProfile: UIButton?
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadConfig()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.backArrow()

        if flow == 1
        {
            self.vcTable.flow = 1
            self.vcTable.stageIdx = self.vcLandscape.StageIdx
            self.vcTable.tableView.reloadData()
            self.navigationController?.navigationBar.gestureRecognizers?.removeAll()
            self.navigationController?.navigationBar.addGestureRecognizer(ActionsTapGestureRecognizer(onTap: {
                
                let vcSelection = Storyboard.getInstanceOf(CitySelectionController.self)
                vcSelection.onSelectedCity = { city in
        
                    self.title = city + self.dropDownChar
                }
        
                let navBar = NavyController(rootViewController: vcSelection)
                
                self.present(navBar, animated: true, completion: nil)
            }))
        }
        else
        {
            self.vcTable.flow = 2
            self.vcTable.stageIdx = self.vcLandscape.StageIdx
            self.vcTable.tableView.reloadData()
        }
        
        var imgProfile: UIImage = flow == 1 ?  #imageLiteral(resourceName: "Richard") :  #imageLiteral(resourceName: "Taylor_raw")
        let height = (imgProfile.cgImage?.height ?? 50) / 2
        imgProfile = maskRoundedImage(image: imgProfile, radius: CGFloat(height))
        
        self.BtnProfile?.setImage(imgProfile, for: .normal)
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
        
        let flow = (UIApplication.shared.delegate as! AppDelegate).flow
        //title
        self.title = "Beverly Hills " + dropDownChar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //Left Button
        self.BtnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        var imgProfile: UIImage = flow == 1 ?  #imageLiteral(resourceName: "Richard") :  #imageLiteral(resourceName: "Taylor_raw")
        let height = (imgProfile.cgImage?.height ?? 50) / 2
        imgProfile = maskRoundedImage(image: imgProfile, radius: CGFloat(height))
        
        self.BtnProfile?.setImage(imgProfile, for: .normal)
        self.BtnProfile?.contentMode = .scaleAspectFit
        self.BtnProfile?.addTarget(self, action: #selector(self.showProfile), for: .touchUpInside)
        
        let barBtnProfile = UIBarButtonItem(customView: self.BtnProfile!)
        let widthConstraint = self.BtnProfile?.widthAnchor.constraint(equalToConstant: 32)
        let heightConstraint = self.BtnProfile?.heightAnchor.constraint(equalToConstant: 32)
        heightConstraint?.isActive = true
        widthConstraint?.isActive = true
        navigationItem.leftBarButtonItem =  barBtnProfile
        
        //Config for Landscape mode
        NotificationCenter.default.addObserver(self, selector: #selector(HomeController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let vcLandscapeScreen = Storyboard.getInstanceOf(LandscapeNavViewController.self)
        self.vcLandscape = vcLandscapeScreen
        self.vcLandscape.OnDidMoveFromLandscape = { stage in
            
            self.showModal(stage)
        }
        self.vcLandscape.onChangeFlow = { flow in
            self.flow = flow
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
        showModal(vcLandscape.StageIdx, animated: true)
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
                if (vcLandscape.StageIdx > 1 && vcLandscape.StageIdx != 3 && vcLandscape.StageIdx != 4) {
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
    
    fileprivate func showModal(_ stage: Int, animated: Bool = false)
    {
        if self.vcLandscape.flow == 1
        {
            self.vcTable.stageIdx = stage
            if stage == 2
            {
                if presentedViewController is ValetParkingController {return}
                
                let vcParking: ValetParkingController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                self.present(vcParking, animated: animated, completion: nil)
            }
            else if stage == 5
            {
                if presentedViewController is HotelCheckInController {return}
                
                let vcHotelCheckin: HotelCheckInController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                self.present(vcHotelCheckin, animated: animated, completion: nil)
            }
            else if stage == 6
            {
                if presentedViewController is RideController {return}
                
                let vcRide: RideController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                self.present(vcRide, animated: animated, completion: nil)
            }
            else if stage == 7
            {
                if presentedViewController is RoomKeyController {return}
                
                let vcRoomKey: RoomKeyController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                self.present(vcRoomKey, animated: animated, completion: nil)
            }
            else if stage == 8
            {
                if presentedViewController is CheckoutController {return}
                
                let vcCheckout: CheckoutController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                vcCheckout.onDeinit = {
                    
                    let vcCheckoutSuccess: CheckoutSuccessController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                    self.present(vcCheckoutSuccess, animated: true, completion: nil)
                }
                
                self.present(vcCheckout, animated: animated, completion: nil)
            }
        }
        else if flow == 2
        {
            if stage == 2
            {
                let vcPorscheValet: PorscheValetTableViewController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                vcPorscheValet.setState(state: .active)
                let navBar = NavyController(rootViewController: vcPorscheValet)
                self.present(navBar, animated: false, completion: nil)
            }
            else if stage == 3
            {
                let vcPorscheValet: PorscheValetTableViewController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                vcPorscheValet.setState(state: .pickupInProgress)
                let navBar = NavyController(rootViewController: vcPorscheValet)
                self.present(navBar, animated: false, completion: nil)
            }
            else if stage == 4
            {
                let vcPorscheValet: PorscheValetTableViewController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                vcPorscheValet.setState(state: .vehicleStandby)
                let navBar = NavyController(rootViewController: vcPorscheValet)
                self.present(navBar, animated: false, completion: nil)
            }
            else if stage == 5
            {
                let vcPorscheValet: PorscheValetTableViewController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                vcPorscheValet.setState(state: .awaitingKeyPickup)
                let navBar = NavyController(rootViewController: vcPorscheValet)
                self.present(navBar, animated: false, completion: nil)
            }           
            
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
            vcTable.parentHome = self
        }
        
        if segue.identifier == "CityActiveFlow2"
        {
            print("Ok")
        }
    }
    
}
