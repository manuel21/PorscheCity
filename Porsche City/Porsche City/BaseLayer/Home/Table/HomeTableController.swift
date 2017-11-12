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
    var parentHome: HomeController?
    var flow = 1
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
            //FLOWS
            if self.flow == 1
            {
                cell.selectionStyle = .none
                cell.imageBody.image =  #imageLiteral(resourceName: "imgStartJoruney")
            }
            else
            {
                cell.selectionStyle = .none
                cell.imageBody.image =  #imageLiteral(resourceName: "iconHomeActive")
            }
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
            cell.selectionStyle = .none
            //FLOWS
            if self.flow == 1
            {
                if stageIdx == 0
                {
                    cell.imageBody.image = #imageLiteral(resourceName: "wine")
                    cell.title.text = "The Wine Merchant"
                    cell.titleDay.text = "This weekend"
                }
                else if stageIdx < 7
                {
                    cell.imageBody.image = #imageLiteral(resourceName: "imgItem1")
                    cell.title.text = "Jazz Concert"
                    cell.titleDay.text = "Tonight"
                }
                else if stageIdx == 7
                {
                    cell.imageBody.image =  #imageLiteral(resourceName: "imgHomeCell")
                    cell.title.text = "Porsche Design"
                    cell.titleDay.text = "Tomorrow"
                }
            }
            else
            {
                if stageIdx < 7
                {
                    cell.imageBody.image = #imageLiteral(resourceName: "PersonalStylist")
                    cell.title.text = "Personal Stylist"
                    cell.titleDay.text = "Today"
                }
                else if stageIdx == 7
                {
                    cell.imageBody.image =  #imageLiteral(resourceName: "imgHomeCell")
                    cell.title.text = "Porsche Design"
                    cell.titleDay.text = "Tomorrow"
                }
            }
            
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell") as! CollectionCell
            if self.flow == 1
            {
                if stageIdx == 0
                {
                    cell.items = ["Jazz Concert", "Avenue of the Stars", "The Garden Bar"]
                    cell.images = ["imgItem1", "starsAvenue", "gardenBar"]
                }
                else //if stageIdx == 1
                {
                    cell.items = ["The Garden Bar",  "Avenue of the Stars", ]
                    cell.images = ["gardenBar", "starsAvenue"]
                }
//                else
//                {
//                    cell.items = ["Jazz Concert", "Porsche Design"]
//                    cell.images = ["imgItem1", "imgItem2"]
//                }
            }
            else
            {
                cell.items = ["Rossano Ferreti", "Montage Spa", "Porsche Design"]
                cell.images = ["RossanoFerreti", "MontageSpa", "imgItem2"]
            }
            cell.reloadCollection()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            if flow == 1
            {
                let vcItinerary = Storyboard.getInstanceOf(ItineraryController.self)
                if stageIdx >= 1  && stageIdx != 3 && stageIdx != 4 {
                    vcItinerary.onBellTapped = {
                        self.parentHome?.openSomething()
                    }
                }
                self.navigationController?.pushViewController(vcItinerary, animated: true)
            } else if self.stageIdx == 1 {
                let vcPorscheValet: PorscheValetTableViewController = Storyboard.getInstanceFromStoryboard(StoryboardName.modals.rawValue)
                let navBar = NavyController(rootViewController: vcPorscheValet)
                self.present(navBar, animated: false, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            if flow == 2
            {
                return stageIdx != 1 ? 0: 90
            }
            else
            {
                return 90
            }
            
            //return flow == 2 && stageIdx == 0 ? 90 : 0
        }
        
        if indexPath.row == 1
        {
            return 300
        }
        
        return 250
    }
}
