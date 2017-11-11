//
//  ProfileTableController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class ProfileTableController: UITableViewController
{
    fileprivate var options = ["Porsche ID", "Payment", "Preferences", "Feedback"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.hideEmtpyCells()
    }
    
    deinit
    {
        print("Deinit: ProfileTableController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier:"Cell")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = UIFont(name: "PNext-Regular", size: 18)
        cell.textLabel?.text = self.options[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.flow == 1
        {
            print("Richard preferences")
            let vcPreferences:PreferencesController = Storyboard.getInstanceFromStoryboard("Main")
            self.navigationController?.pushViewController(vcPreferences, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}
