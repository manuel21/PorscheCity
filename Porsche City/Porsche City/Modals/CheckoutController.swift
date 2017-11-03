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
    var onDeinit:(() -> ())?
    
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
    
    deinit
    {
        print("Deinit: CheckoutController")
        self.onDeinit?()
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
    
    @IBAction func sendNotification()
    {
        (UIApplication.shared.delegate as? AppDelegate)?.createNotification(type: .hotelValet)
        print("Send checkout notification")
    }
    
    @IBAction func checkout(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
}
