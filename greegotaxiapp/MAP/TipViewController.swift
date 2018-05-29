//
//  TipViewController.swift
//  greegotaxiapp
//
//  Created by Ravi Dubey on 5/29/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import CTCheckbox
class TipViewController: UIViewController {

    
    
    var drivername: String = ""
    
    @IBOutlet weak var btn10: UIButton!
    
    @IBOutlet weak var btn15: UIButton!
    
    @IBOutlet weak var btn20: UIButton!
    
    
    @IBOutlet weak var txttip: UITextField!
    
    @IBOutlet weak var cb: CTCheckbox!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setshadow(myBtn: btn10)
        setshadow(myBtn: btn15)
        setshadow(myBtn: btn20)


        // Do any additional setup after loading the view.
    }

    
    func setshadow(myBtn:UIButton)
    {
       
        myBtn.layer.shadowColor = UIColor.black.cgColor
        myBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        myBtn.layer.masksToBounds = false
        myBtn.layer.shadowRadius = 1.0
        myBtn.layer.shadowOpacity = 0.5
        myBtn.layer.cornerRadius = myBtn.frame.width / 2
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnnextaction(_ sender: Any) {
        
     if(cb.checked == false || txttip.text == "")
     {
        let alert = UIAlertController(title: nil, message: "Please choose tip option", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
        }
        else
     {
        
        
        
        }
        
        
        
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
