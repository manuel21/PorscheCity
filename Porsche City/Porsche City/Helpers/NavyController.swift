//
//  NavyController.swift
//  BCM
//
//  Created by Nestor Javier Hernandez Bautista on 8/30/16.
//  Copyright © 2016 Nestor Javier Hernandez Bautista. All rights reserved.
//

import UIKit

class NavyController: UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationBar.barTintColor = .white
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor    = .black
    }
}
