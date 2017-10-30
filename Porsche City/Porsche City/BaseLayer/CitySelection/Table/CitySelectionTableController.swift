//
//  CitySelectionTableController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class CitySelectionTableController: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.hideEmtpyCells()
    }
    
    deinit
    {
        print("Deinit: CitySelectionTableController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier:"Cell")
        
        //Color for selected cell
        let selectedColor = UIView()
        selectedColor.layer.backgroundColor = UIColor.white.cgColor
        cell.selectedBackgroundView = selectedColor
        
        cell.textLabel?.text = "hola"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
}
