//
//  EmailVC.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 09/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class EmailVC: UIViewController {

    @IBOutlet weak var txtemail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    
    
    //MARK: - IBAction Methods

    @IBAction func nextaction(_ sender: Any) {
        
     if(isValidEmail(testStr: txtemail.text!))
     {
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "nameViewController") as! nameViewController
        self.navigationController?.pushViewController(vc, animated: true)
        let user = UserDefaults.standard
        
        user.set(txtemail.text!, forKey: "email")
        
        user.synchronize()
        
    }
else
     {
     
        
        let alert = UIAlertController(title: nil, message: "Please enter correct Email Address", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        }
        
        
    }
   
     // MARK: - user define functions
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func btnBackClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
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
