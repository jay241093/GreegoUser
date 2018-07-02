//
//  mobilenumberViewController.swift
//  greegotaxiapp
//
//  Created by jay on 4/2/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class mobilenumberViewController: UIViewController ,UITextFieldDelegate{
    
 //  @IBOutlet weak var txtMobileNum: UITextField!
  
    @IBOutlet weak var txtnum: UITextField!
    
//MARK: - Delegate Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        
      if let key = UserDefaults.standard.object(forKey:"status")
      {
        let num = UserDefaults.standard.value(forKey: "status") as! String
        
        if(num == "1")
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DrideMapVC") as! DrideMapVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
             if let key = UserDefaults.standard.object(forKey:"userinfo")
             {
                
              let dic = UserDefaults.standard.value(forKey:"userinfo") as! NSDictionary
                print(dic)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
            }
            nextViewController.isfrommain = 1

        }
        
       else if(num == "2")
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DrideMapVC") as! DrideMapVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            if let key = UserDefaults.standard.object(forKey:"userinfo")
            {
                
                let dic = UserDefaults.standard.value(forKey:"userinfo") as! NSDictionary
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
            }
            
            nextViewController.isfrommain = 1

        }
        else if(num == "3")
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OnTripVC") as! OnTripVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            if let key = UserDefaults.standard.object(forKey:"userinfo")
            {
                
                let dic = UserDefaults.standard.value(forKey:"userinfo") as! NSDictionary
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
            }
            nextViewController.isfrommain = 1

        }
        else if(num == "4")
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OnTripVC") as! OnTripVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            if let key = UserDefaults.standard.object(forKey:"userinfo")
            {
                
                let dic = UserDefaults.standard.value(forKey:"userinfo") as! NSDictionary
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
            }
            nextViewController.isfrommain = 1

        }
        
        
        
        
        
        }
        
        
     else
      {
        
       if let key = UserDefaults.standard.object(forKey: "islogin")
       {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
        
        }
        
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
//MARK: - Textfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) 
    {
        //textField.endEditing(true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addMobileVC") as! addMobileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
  
}
