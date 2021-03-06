//
//  ProfileController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class ProfileController: UIViewController
{
    //MARK: PROPERTIES & OUTLETS
    @IBOutlet weak fileprivate var btnLogout: UIButton!
    fileprivate var vcTable: ProfileTableController!
    
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
        print("Deinit: ProfileController")
    }
    
    //MARK: CONFIG
    fileprivate func loadConfig()
    {
        let flow = (UIApplication.shared.delegate as! AppDelegate).flow
        //title
        self.title = flow == 1 ? "Richard Parker": "Taylor Miller"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //Border
        self.btnLogout.setBorderAndCornerRadius()
        
        //Left Button
        let BtnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        var imgProfile: UIImage = flow == 1 ?  #imageLiteral(resourceName: "Richard") : #imageLiteral(resourceName: "Taylor_raw")
        let height = (imgProfile.cgImage?.height ?? 50) / 2
        imgProfile = maskRoundedImage(image: imgProfile, radius: CGFloat(height))
        BtnProfile.setImage(imgProfile, for: .normal)
        BtnProfile.contentMode = .scaleAspectFit
        BtnProfile.isEnabled = false
        
        let barBtnProfile = UIBarButtonItem(customView: BtnProfile)
        let widthConstraint = BtnProfile.widthAnchor.constraint(equalToConstant: 32)
        let heightConstraint = BtnProfile.heightAnchor.constraint(equalToConstant: 32)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  barBtnProfile
        
        //Close Button
        let barBtnClose = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action:#selector(self.close))
        self.navigationItem.rightBarButtonItem = barBtnClose
    }
    
    //MARK: ACTIONS
    @objc fileprivate func close()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier , id == "ProfileTableController" {
            
            self.vcTable = segue.destination as! ProfileTableController
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
}

