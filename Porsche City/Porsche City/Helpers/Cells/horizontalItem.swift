//
//  UpdatedEventCell.swift
//  BCM
//
//  Created by Manuel Salinas on 9/1/17.
//  Copyright © 2017 Nestor Javier Hernandez Bautista. All rights reserved.
//

import UIKit

class horizontalItem: UICollectionViewCell
{
    //MARK: OUTLETS & PROPERTIES
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    //MARK: LIFE CYCLE
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.setBorder(cornerRadius: true)
    }
}
