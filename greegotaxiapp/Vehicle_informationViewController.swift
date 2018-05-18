//
//  Vehicle_informationViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/5/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import DropDown

class Vehicle_informationViewController: UIViewController {
    
    @IBOutlet weak var dropDown: HADropDown!
    
    @IBOutlet weak var dropdown3: HADropDown!
    
    @IBOutlet weak var dropdown2: HADropDown!
    
    @IBOutlet weak var dropdown4: HADropDown!
    override func viewDidLoad() {
        
         dropDown.items = ["Cat", "Mouse", "Horse", "Elephant", "Dog", "Zebra"]
        
        dropdown2.items = ["Cat", "Mouse", "Horse", "Elephant", "Dog", "Zebra"]
        
        dropdown3.items = ["Cat", "Mouse", "Horse", "Elephant", "Dog", "Zebra"]
        
        dropdown4.items = ["Cat", "Mouse", "Horse", "Elephant", "Dog", "Zebra"]
        super.viewDidLoad()
        
      
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
