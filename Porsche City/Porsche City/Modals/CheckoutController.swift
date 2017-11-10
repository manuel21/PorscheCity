//
//  CheckoutController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 11/1/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class CheckoutController: UIViewController
{
    //MARK: PROPERTIES & OUTLETS
    @IBOutlet weak fileprivate var ivCheckout: UIImageView!
    @IBOutlet weak fileprivate var ivCheckoutSuccess: UIImageView!
    @IBOutlet weak fileprivate var ivSlideText: UIImageView!
    @IBOutlet weak fileprivate var ivCheckoutCard: UIImageView!
    @IBOutlet weak fileprivate var btnNotification: UIButton!
    @IBOutlet weak fileprivate var contraintCard: NSLayoutConstraint!
    
    var onDeinit:(() -> ())?
    fileprivate var wasSlide = false
    let screenHeight = UIScreen.main.bounds.size.height
    var finalFrame: CGRect!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        
        self.ivCheckoutSuccess.alpha = 0
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
        print("Deinit: CheckoutController")
        self.onDeinit?()
    }

    //MARK: ACTIONS
    @IBAction func close()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendNotification()
    {
        (UIApplication.shared.delegate as? AppDelegate)?.scheduleNotification(type: .hotelValet)
        print("Send checkout notification")
    }
    
    @IBAction func checkout(_ sender: Any)
    {
        //iphone 8 = 667
        //iphone 8 plus = 736
        //Constraint original 118
        
        if self.wasSlide == false
        {
            self.wasSlide = true
            
            //Slide Down
             UIView.animate(withDuration: 0.5,  animations: {
                
                self.contraintCard.constant = 24
                self.view.layoutIfNeeded()
                
            }, completion: { complete in
                
                self.ivSlideText.isHidden = true
                
                //Change status card
                UIView.animate(withDuration: 0.3,  animations: {

                    self.ivCheckoutCard.alpha = 0

                }, completion: { complete in

                    self.ivCheckoutCard.image = #imageLiteral(resourceName: "iconCheckoutPassSuccess")
                    
                    //Show success checkout
                    UIView.animate(withDuration: 0.3,  animations: {
                        
                        self.ivCheckoutCard.alpha = 1
                        self.ivCheckout.alpha = 0
                        
                    }, completion: { complete in
                        
                        UIView.animate(withDuration: 0.2,  animations: {
                            
                            self.ivCheckoutSuccess.alpha = 1
                            self.btnNotification.isEnabled = false
                        })
                    })
                    
                })
                
            })
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
}
