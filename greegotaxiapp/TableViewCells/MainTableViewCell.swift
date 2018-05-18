//
//  MainTableViewCell.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/4/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell
{

    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var amtlbl: UILabel!
    
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var view: UIView!
    
//MARK: - Delegate Methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    
//MARK: - IBAction Methods

    @IBAction func nextbtn(_ sender: Any)
    {
        
    }

}
