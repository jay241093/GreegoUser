//
//  SettingViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/14/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class SettingViewController: UIViewController {
 
    @IBOutlet weak var lbljoin: UILabel!
    
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var secondview: UIView!
    @IBOutlet weak var thirdview: UIView!
    @IBOutlet weak var forthview: UIView!
    @IBOutlet weak var fifthview: UIView!
  
    @IBOutlet weak var txtfname: UILabel!
    
    @IBOutlet weak var txtemil: UILabel!
    
    @IBOutlet weak var txtmobile: UILabel!
    
    @IBOutlet weak var profileimg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserDefaults.standard.value(forKey:"CreatedAt") as? String)
        
        let str = UserDefaults.standard.value(forKey:"CreatedAt") as? String
        lbljoin.text = "Created On " + str!
        
        thirdview.isUserInteractionEnabled = true
        secondview.isUserInteractionEnabled = true

        let tap1 = UITapGestureRecognizer()
        
        tap1.addTarget(self, action: #selector(updateprofile))
        secondview.addGestureRecognizer(tap1)
        
        
        let tap = UITapGestureRecognizer()
        
        tap.addTarget(self, action: #selector(Verifyemail))
        thirdview.addGestureRecognizer(tap)
        
        
        profileimg.layer.borderWidth=1.0
        profileimg.layer.masksToBounds = false
        profileimg.layer.borderColor = UIColor.white.cgColor
        profileimg.layer.cornerRadius = profileimg.frame.size.height/2
        profileimg.clipsToBounds = true
        
        self.setShadow(view: firstview)
        self.setShadow(view: secondview)
        self.setShadow(view: thirdview)
        self.setShadow(view: forthview)
        self.setShadow(view: fifthview)
       
        
        let  firstname = UserDefaults.standard.value(forKey: "fname") as! String
        let  lastname = UserDefaults.standard.value(forKey: "lname") as! String
        let  email1 = UserDefaults.standard.value(forKey: "email") as! String
        let  mobile1 = UserDefaults.standard.value(forKey: "mobile") as! String
        
        txtfname.text = firstname + " " + lastname
        txtmobile.text = mobile1
        txtemil.text = email1
        
        if let key = UserDefaults.standard.object(forKey: "profile_pic"){
            
            var profile =   UserDefaults.standard.value(forKey: "profile_pic")as! String
            
            
            var catPictureURL = NSURL(string: profile)
            
            self.profileimg.sd_setImage(with: catPictureURL as! URL, placeholderImage: UIImage(named: "default-user"))
            //self.updateprofileimg.image = image
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func updateprofile()
    {
        
     
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateprofileViewController") as! UpdateprofileViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @objc func Verifyemail()
  {
        if AppDelegate.hasConnectivity() == true
    {
        WebServiceClass().showprogress()
        let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        let parameters = [
            "device_id": UserDefaults.standard.value(forKey: "Token") as! String
            
        ]
        
        
        Alamofire.request(WebServiceClass().BaseURL+"user/verify/email", method: .post, parameters:[:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                WebServiceClass().dismissprogress()
                
                if let data = response.result.value{
                    print(response.result.value!)
                    
                  
                    
                    
                    let dic: NSDictionary =  response.result.value! as! NSDictionary
                    
                    if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                    {
                   
                        
                        let dialogMessage = UIAlertController(title: nil, message:"Email Sent Successfully", preferredStyle: .alert)
                        
                      
                        // Create Cancel button with action handlder
                        let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                        }
                        
                        //Add OK and Cancel button to dialog message
                        dialogMessage.addAction(cancel)
                        
                        // Present dialog message to user
                        self.present(dialogMessage, animated: true, completion: nil)
                        
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
    
    
    
    func setShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 2
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnlogout(_ sender: Any) {
        
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout ?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "mobilenumberViewController") as! mobilenumberViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDel.window?.rootViewController = loginVC
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
           
        }))
        
        present(refreshAlert, animated: true, completion: nil)
   
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to Logout?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            UserDefaults.standard.removeObject(forKey: "fname")
            UserDefaults.standard.removeObject(forKey: "lname")
            UserDefaults.standard.removeObject(forKey: "email")
            
            UserDefaults.standard.removeObject(forKey: "mobile")
            
            UserDefaults.standard.removeObject(forKey: "islogin")
            
            UserDefaults.standard.removeObject(forKey: "user_id")
            
            UserDefaults.standard.removeObject(forKey: "profile_pic")
            UserDefaults.standard.removeObject(forKey: "CreatedAt")
            UserDefaults.standard.removeObject(forKey: "DriverImg")
            UserDefaults.standard.removeObject(forKey: "Drivername")
            UserDefaults.standard.synchronize()
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "mobilenumberViewController") as! mobilenumberViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
     
        
    }
    
    

}
