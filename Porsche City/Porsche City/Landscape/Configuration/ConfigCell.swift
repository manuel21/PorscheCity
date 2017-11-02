//
//  ConfigCell.swift
//  Porsche City
//
//  Created by Nestor Javier Hernandez Bautista on 11/2/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class ConfigCell: UITableViewCell
{

    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
