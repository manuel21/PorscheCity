//
//  PorscheValetViewController.swift
//  Porsche City
//
//  Created by Gerardo on 07/11/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

enum PorscheValetState {
    case standby
    case active
    case awaitingKeys
    case pickupInProgress
    case vehicleStandby
    case deliveryInProgress
    case awaitingKeyPickup
}

class PorscheValetTableViewController: UITableViewController {
    
    var state: PorscheValetState = .standby
    private var mapImages: [PorscheValetState: String] = [
                             .standby: "mapStandby",
                             .active: "mapActive",
                             .awaitingKeys: "mapAwaitingKeys",
                             .pickupInProgress: "mapPickupInProgress",
                             .vehicleStandby: "mapVehicleStandby",
                             .deliveryInProgress: "mapAwaitingKeyPickup",
                             .awaitingKeyPickup: "mapAwaitingKeyPickup"]
    private var stateImages: [PorscheValetState: String] = [
        .standby: "stateStandby",
        .active: "stateActive",
        .awaitingKeys: "stateAwaitingKeys",
        .pickupInProgress: "statePickupInProgress",
        .vehicleStandby: "stateVehicleStandby",
        .deliveryInProgress: "stateDeliveryInProgress",
        .awaitingKeyPickup: "stateAwaitingKeyPickup"]
    
    
    private var statusImageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Porsche Valet"

        tableView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
        tableView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
        
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "❮", style: .plain, target: self, action: #selector(close))
        
        tableView.contentInset.bottom = 10
    }
    
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state == .deliveryInProgress || state == .awaitingKeyPickup ? 2 : 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 350 : indexPath.row == 1 ? 150 : 180
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewCell
            cell.imageBody.image = UIImage(named: indexPath.row == 0 ? mapImages[state]! : stateImages[state]!)
            cell.imageBody.contentMode = .scaleAspectFill
            return cell
            
        default:
            if state == .vehicleStandby {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewCell
                cell.imageBody.image = UIImage(named: "cleanLarge")
                cell.imageBody.contentMode = .scaleToFill
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell") as! CollectionCell
            cell.items = ["Premium Fuel", "Deluxe Detail"]
            cell.images = ["fuel", "clean"]
            cell.cellWidth = 250
            cell.imageContentMode = .scaleToFill
            cell.adoptCollectionViewHeight = true
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 1 {
            if state == .active {
                (UIApplication.shared.delegate as? AppDelegate)?.scheduleNotification(type: .porscheValet)
                state = .awaitingKeys
                tableView.contentOffset.y = 0
                tableView.reloadData()
                
            } else if state == .vehicleStandby {
                (UIApplication.shared.delegate as? AppDelegate)?.scheduleNotification(type: .porscheValet2)
                state = .deliveryInProgress
                tableView.contentOffset.y = 0
                tableView.reloadData()
            }
        }
    }

}
