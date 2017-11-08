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
    fileprivate var items = ["Beverly Hills", "San Francisco"]
    var selectedCity = "Beverly Hills"
    var onSelect:(() -> ())?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.hideEmtpyCells()
        self.tableView.separatorColor = .clear
        self.tableView.register(UINib(nibName: "ImageViewTextCell", bundle: nil), forCellReuseIdentifier: "ImageViewTextCell")
    }
    
    deinit
    {
        print("Deinit: CitySelectionTableController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewTextCell") as! ImageViewTextCell
        cell.selectionStyle = .none
        cell.imageBody.image = indexPath.row %  2 == 0 ? #imageLiteral(resourceName: "selectionCell_1") : #imageLiteral(resourceName: "selectionCell_2")
        cell.title.text = self.items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedCity = self.items[indexPath.row]
        
        self.onSelect?()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250
    }
}
