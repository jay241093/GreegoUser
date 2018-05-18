//
//  VehicleTableViewCell.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/23/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var selectimg: UIImageView!
    @IBOutlet weak var vehicleview: UIView!
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var btnvehicle: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
      
        // Configure the view for the selected state
    }

}
