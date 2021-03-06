//
//  CityActiveFlow2TableViewController.swift
//  Porsche City
//
//  Created by Nestor Javier Hernandez Bautista on 11/5/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class CityActiveFlow2TableViewController: UITableViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.hideEmtpyCells()
        self.tableView.separatorColor = .clear
        self.tableView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0
        {
            cell.imageBody.image =  #imageLiteral(resourceName: "CitiActiveFlow2_1")
        }
        else if indexPath.row == 1
        {
            cell.imageBody.image =  #imageLiteral(resourceName: "imgItem2")
        }
        else
        {
            cell.imageBody.image =  #imageLiteral(resourceName: "CitiActiveFlow2_3")
            
        }
        
        
        return cell
    }
    
    /*
   
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
