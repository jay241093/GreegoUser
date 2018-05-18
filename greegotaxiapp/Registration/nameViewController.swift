//
//  nameViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/2/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class nameViewController: UIViewController
{

    @IBOutlet weak var txtfirstname: UITextField!
    @IBOutlet weak var txtlastname: UITextField!
    
//MARK: - Delegate Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: txtfirstname.frame.size.height - width, width:  txtfirstname.frame.size.width, height: txtfirstname.frame.size.height)
        
        border.borderWidth = width
        txtfirstname.layer.addSublayer(border)
        txtfirstname.layer.masksToBounds = true
        
        let border1 = CALayer()
        let width1 = CGFloat(2.0)
        border1.borderColor = UIColor.darkGray.cgColor
        border1.frame = CGRect(x: 0, y: txtlastname.frame.size.height - width1, width:  txtlastname.frame.size.width, height: txtlastname.frame.size.height)
        
        border1.borderWidth = width1
        txtlastname.layer.addSublayer(border1)
        txtlastname.layer.masksToBounds = true
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //MARK: - IBAction Methods

    @IBAction func nextaction(_ sender: Any) {
       if(txtfirstname.text == "")
       {
        
        let alert = UIAlertController(title: "Greego", message: "Please Enter Firstname", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        }
      else  if(txtlastname.text == "")
        {
            
            let alert = UIAlertController(title: "Greego", message: "Please Enter Lastname", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
       else
       {
        
        let user = UserDefaults.standard
        
        user.set(txtfirstname.text!, forKey: "fname")
        user.set(txtlastname.text!, forKey: "lname")

        user.synchronize()
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermandconditionVC") as! TermandconditionVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
        
        
    }
    
    @IBAction func btnBackClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
