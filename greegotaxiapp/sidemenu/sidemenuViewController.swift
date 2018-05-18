//
//  sidemenuViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 03/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class sidemenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imguser: UIImageView!
    
    @IBOutlet weak var heightview: NSLayoutConstraint!
    
    @IBOutlet weak var fname: UILabel!
    var reuseid = NSMutableArray()
    
    //MARK: - Delegate Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(UIDevice.current.screenType == .iPhoneX)
        {
          heightview.constant = 250
            
        }
        
        
        
        reuseid = ["cell0","cell","cell1","cell2","cell3","cell4"]
        imguser.layer.borderWidth=1.0
        imguser.layer.masksToBounds = false
        imguser.layer.borderColor = UIColor.white.cgColor
        imguser.layer.cornerRadius = imguser.frame.size.height/2
        imguser.clipsToBounds = true
        
        
  
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let key = UserDefaults.standard.object(forKey: "profile_pic"){
            
            var profile =   UserDefaults.standard.value(forKey: "profile_pic")as! String
            
            
            var catPictureURL = NSURL(string: profile)
            
            self.imguser.sd_setImage(with: catPictureURL as! URL, placeholderImage: UIImage(named: "default-user"))
            //self.updateprofileimg.image = image
        }
        let  firstname = UserDefaults.standard.value(forKey: "fname") as! String
        let  lastname = UserDefaults.standard.value(forKey: "lname") as! String
        
        
        fname.text = firstname + " " + lastname
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reuseid.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let str = reuseid.object(at: indexPath.row) as! String
        let dvc:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:str, for: indexPath)
        var nameary = ["Home","Payment","Your Trips","Free Rides","Help","Settings"]
        dvc.textLabel?.text = nameary[indexPath.row]
        
        
        return dvc
    }
    
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}

