//
//  PreferencesTableController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class PreferencesTableController: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.hideEmtpyCells()
        self.tableView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
        self.tableView.separatorColor = .gray
    }
    
    deinit
    {
        print("Deinit: PreferencesTableController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0
        {
            cell.imageBody.image = #imageLiteral(resourceName: "Food&Cocine")
        }
        else if indexPath.row == 1
        {
            cell.imageBody.image = #imageLiteral(resourceName: "entretainment")
        }
        else if indexPath.row == 2
        {
            cell.imageBody.image = #imageLiteral(resourceName: "accomodation")
        }
        else
        {
            cell.imageBody.image = #imageLiteral(resourceName: "Vehicle&mobility")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 200
        }
        else if indexPath.row == 1
        {
            return 150
        }
        else if indexPath.row == 2
        {
            return 250
        }
        else
        {
            return 150
        }
    }
}
