//
//  HomeTableController.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class HomeTableController: UITableViewController
{
    var stageIdx = 0 {
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.hideEmtpyCells()
        self.tableView.separatorColor = .clear
        self.tableView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
        self.tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        self.tableView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
    }
    
    deinit
    {
        print("Deinit: HomeTableController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewCell
            cell.selectionStyle = .none
            cell.imageBody.image = #imageLiteral(resourceName: "imgStartJoruney")
        
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
            cell.selectionStyle = .none
            if stageIdx == 0
            {
                cell.imageBody.image = #imageLiteral(resourceName: "imgHomeCell")
                cell.title.text = "Club 993"
                cell.titleDay.text = "This weekend"
            }
            else if stageIdx < 7
            {
                cell.imageBody.image = #imageLiteral(resourceName: "imgItem1")
                cell.title.text = "Concert"
                cell.titleDay.text = "Tonight"
            }
            else if stageIdx == 7
            {
                cell.imageBody.image =  #imageLiteral(resourceName: "imgHomeCell")
                cell.title.text = "Club 993"
                cell.titleDay.text = "This weekend"
            }
            
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell") as! CollectionCell
            cell.images = ["imgItem1", "imgItem2", "imgItem1", "imgItem2", "imgItem1"]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vcItinerary: PorscheValetTableViewController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
//        let vcItinerary = Storyboard.getInstanceOf(ItineraryController.self)
        self.navigationController?.pushViewController(vcItinerary, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 90
        }
        else if indexPath.row == 1
        {
            return 300
        }
        else
        {
            return 250
        }
    }
}
