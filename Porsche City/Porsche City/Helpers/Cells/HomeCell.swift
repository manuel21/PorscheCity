//
//  HomeCell.swift
//  Porsche City
//
//  Created by Manuel Salinas on 11/7/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell
{
    @IBOutlet weak var titleDay: UILabel!
    @IBOutlet weak var filters: UIButton!
    @IBOutlet weak var imageBody: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    //MARK: LIFE CYCLE
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.titleDay.text = "This weekend"
        self.cardView.setBorder(cornerRadius: true)
    }
}
