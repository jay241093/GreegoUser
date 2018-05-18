//
//  EmailverificationViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/5/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class EmailverificationViewController: UIViewController {

    @IBOutlet weak var textview: UIView!
    
    
    @IBOutlet weak var emailview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textview.layer.shadowColor = UIColor.lightGray.cgColor
        textview.layer.shadowOpacity = 0.5
        textview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        textview.layer.shadowRadius = 2
        
        emailview.layer.shadowColor = UIColor.lightGray.cgColor
        emailview.layer.shadowOpacity = 0.5
        emailview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        emailview.layer.shadowRadius = 2
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
