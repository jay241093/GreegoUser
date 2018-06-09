//
//  EmailverificationViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/5/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class EmailverificationViewController: UIViewController
{

    @IBOutlet weak var textview: UIView!
    @IBOutlet weak var emailview: UIView!
    
 //MARK: - Delegate Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.setShadow(view: textview)
        self.setShadow(view: emailview)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: - User Define Functions
    
    func setShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 2
    }
}
