//
//  paymentcell.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/21/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class paymentcell: UITableViewCell {
    @IBOutlet weak var lblnum: UILabel!
    
    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var numview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if(selected){
//            img.image = UIImage(named: "tick")
//        }else{
//            img.image = UIImage(named: "cross")
//        }
        // Configure the view for the selected state
    }

}
