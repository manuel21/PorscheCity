//
//  CityActiveFlow2ViewController.swift
//  Porsche City
//
//  Created by Nestor Javier Hernandez Bautista on 11/5/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class CityActiveFlow2ViewController: UIViewController {

    var vcCityActive: CityActiveFlow2TableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier , id == "HomeTableController" {
            self.vcCityActive = segue.destination as? CityActiveFlow2TableViewController
        }
        
        if segue.identifier == "CityActiveFlow2"
        {
            print("Ok")
        }
    }

}
