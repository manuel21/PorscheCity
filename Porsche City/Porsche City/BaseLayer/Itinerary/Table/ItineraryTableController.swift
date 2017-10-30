//
//  ItineraryTableController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class ItineraryTableController: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.hideEmtpyCells()
        self.tableView.separatorColor = .clear
        self.tableView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
        self.tableView.register(UINib(nibName: "CollectionCell_Clone", bundle: nil), forCellReuseIdentifier: "CollectionCell_Clone")
    }
    
    deinit
    {
        print("Deinit: ItineraryTableController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row %  2 == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewCell
            cell.selectionStyle = .none
            cell.imageBody.image = #imageLiteral(resourceName: "imgItineraryCell")
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell_Clone") as! CollectionCell_Clone
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return indexPath.row == 1 ? 200 : 500
    }
}
