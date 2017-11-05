//
//  ConfigurationController.swift
//  Porsche City
//
//  Created by Nestor Javier Hernandez Bautista on 11/2/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class ConfigurationController: UIViewController
{

    @IBOutlet weak var switchSteps: UISwitch!
    @IBOutlet weak var switchSeconds: UISwitch!
    @IBOutlet weak var txtSteps: UITextField!
    @IBOutlet weak var txtSeconds: UITextField!
    @IBOutlet weak var lblFlow: UILabel!
    
    @IBOutlet weak var switchFlow: UISwitch!
    var seconds = 10
    var steps = 0
    var onSetConfiguration:((_ seconds:Int, _ steps:Int)->())?
    var onCancel:(()->())?
    var onJourneyByTime:((_ journeyByTime: Bool)->())?
    var onChangeFlow:((_ flow:Int)->())?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.switchSeconds.isOn = true
        self.txtSeconds.text = "\(10) seconds"
        self.switchSteps.isOn = false
        
        self.txtSeconds.keyboardType = .numberPad
        self.txtSeconds.delegate = self
        self.txtSeconds.tag = 1
        
        self.txtSteps.keyboardType = .numberPad
        self.txtSteps.tag = 2
        self.txtSteps.delegate = self
        
        self.lblFlow.text = "Flow 1"
        self.switchFlow.isOn = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func activateSeconds(_ sender: Any)
    {
        if self.switchSeconds.isOn == true
        {
            self.seconds = 10
            self.txtSeconds.text = "\(self.seconds) seconds"
            
            self.switchSteps.isOn = false
            self.txtSteps.text = String()
        }
        else
        {
            self.seconds = 0
            self.txtSeconds.text = String()
        }
    }
    
    @IBAction func activateSteps(_ sender: Any)
    {
        if self.switchSteps.isOn == true
        {
            self.steps = 10
            self.txtSteps.text = "\(self.steps) steps"
            
            
            self.switchSeconds.isOn = false
            
            self.txtSeconds.text = String()
        }
        else
        {
            self.steps = 0
            self.txtSteps.text = String()
        }
    }
    
    @IBAction func changeFlow(_ sender: Any)
    {
        if self.switchFlow.isOn == true
        {
            self.onChangeFlow?(1)
            self.lblFlow.text = "flow 1"
        }
        else
        {
            self.onChangeFlow?(2)
            self.lblFlow.text = "flow 2"
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any)
    {
        self.onCancel?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setConfig(_ sender: Any)
    {
        self.view.endEditing(true)
        self.resignFirstResponder()
        self.onSetConfiguration?(self.switchSeconds.isOn == true ? self.seconds : 0, self.switchSteps.isOn == true ? self.steps : 0)
        self.onJourneyByTime?(self.switchSeconds.isOn == true)
        if(self.switchSeconds.isOn == false && self.switchSteps.isOn == false)
        {
            self.onCancel?()
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension ConfigurationController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.tag == 1
        {
            textField.text = String()
            guard self.switchSeconds.isOn == true else {
                self.txtSeconds.endEditing(true)
                self.txtSeconds.resignFirstResponder()
                return
            }
        }
        else if textField.tag == 2
        {
            textField.text = String()
            guard self.switchSteps.isOn == true else {
                self.txtSteps.endEditing(true)
                self.txtSteps.resignFirstResponder()
                return
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 1
        {
            self.seconds =  Int(self.txtSeconds.text ?? String()) ?? 0
            self.txtSeconds.text = "\(self.seconds) seconds"
        }
        
        if textField.tag == 2
        {
            self.steps =  Int(self.txtSteps.text ?? String()) ?? 0
            self.txtSteps.text = "\(self.steps) steps"
        }
    }
}
