//
//  addMobileVC.swift
//  greegotaxiapp
//
//  Created by mac on 06/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire
class addMobileVC: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var txtMobileNum: UITextField!
    
    
//MARK: - Delegate Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtMobileNum.becomeFirstResponder()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
      txtMobileNum.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - IBAction Methods
    @IBAction func btnBackClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: Any)
    {
        
       
        if(txtMobileNum.text == "")
      {
        let alert = UIAlertController(title: nil, message: "Please enter correct mobile number", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        
       else
      {
     
        checkmobile()
    
    
       
        }
        }

    
    //MARK: - USER DEFINE FUNCTIONS
func checkmobile()
{
    if AppDelegate.hasConnectivity() == true
    {
        
        WebServiceClass().showprogress()
        print( UserDefaults.standard.value(forKey: "Token") as! String)
        let parameters = [
            "contact_number":"+1" + txtMobileNum.text!,
            "is_iphone": "1",
            "device_id": UserDefaults.standard.value(forKey: "Token") as! String
        ]
        
        Alamofire.request(WebServiceClass().BaseURL+"login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                
                WebServiceClass().dismissprogress()

                if let data = response.result.value{
                    print(response.result.value!)
                    
                    
                    
                    
                    let dic: NSDictionary =  response.result.value! as! NSDictionary
                    
                   if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                   {
                    var datadic :NSDictionary = dic.value(forKey: "data") as! NSDictionary
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "otpVC") as! otpVC
                    
                    let otpstring = datadic.value(forKey: "otp") as! NSNumber
                    let devicetoken =  datadic.value(forKey: "token") as! String
                    nextViewController.strmobileno = self.txtMobileNum.text!
                    nextViewController.strotp = otpstring.stringValue
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                    let user = UserDefaults.standard
                    
                    user.set(devicetoken, forKey: "devicetoken")
                    user.synchronize()
                    
                    
                    }
                    else
                   {
                    let alert = UIAlertController(title: nil, message: "Please enter correct mobile number.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    }
                    
                }
                break
                
            case .failure(_):
                WebServiceClass().dismissprogress()

                print(response.result.error)
                break
                
            }
        }
   
    }
    else
    {
        WebServiceClass().nointernetconnection()
    NSLog("No Internet Connection")
    }
    
}
    
    
    
}
