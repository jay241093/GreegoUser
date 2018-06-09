//
//  DriverPopupVC.swift
//  greegotaxiapp
//
//  Created by Viper on 24/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SANotificationViews
class DriverPopupVC: UIViewController {

    @IBOutlet weak var lblpromocode: UILabel!
    @IBOutlet weak var lblcardnum: UILabel!
    @IBOutlet weak var lblprice: UILabel!
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var userpic: UIImageView!
    
    
    @IBOutlet weak var lblusername: UILabel!
    
    
    @IBOutlet weak var lbldesname: UIButton!
    
    var tripcost: String = ""
    var cardnum: String = ""

    var contct : String = ""
    var tripid : String = ""
    var reqid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblprice.text = "$US " + tripcost

        lblcardnum.text = "Ending with " + cardnum
        shadow(view: view1)
        shadow(view: view2)
        shadow(view: view3)

        view1.layer.cornerRadius = 18.0
        view2.layer.cornerRadius = 18.0
        view3.layer.cornerRadius = 18.0

        userpic.layer.borderWidth = 1
        userpic.layer.masksToBounds = false
        userpic.layer.cornerRadius = userpic.frame.height/2
        userpic.clipsToBounds = true

        
        getdriverdetail()
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)

        showAnimate()
        // Do any additional setup after loading the view.
    }

    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
 func getdriverdetail()
 {
    if AppDelegate.hasConnectivity() == true
    {
        
        WebServiceClass().showprogress()
        let ID:Int? = Int(tripid) // firstText is UITextField

        print(ID!)
        let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        let parameters = [
            "trip_id" : ID!
            ] as [String : Any]
        
        Alamofire.request(WebServiceClass().BaseURL+"user/get/tripdetails", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
            case .success(_):
                WebServiceClass().dismissprogress()
                let dic: NSDictionary =  response.result.value! as! NSDictionary
                
                if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                {
                    print(response.result.value!)
                    let newdic : NSDictionary =  dic.value(forKey: "data") as! NSDictionary
                    
                    let driverdic = newdic.value(forKey: "driver") as! NSDictionary
                   
                   let first = driverdic.value(forKey: "name") as! String
                    let last = driverdic.value(forKey: "lastname") as! String

                    self.lblusername.text = first + " " + last
                    self.lblpromocode.text = driverdic.value(forKey:"promocode") as? String
                    let reqdic: NSDictionary = newdic.value(forKey:"request") as! NSDictionary
                    self.lbldesname.setTitle(reqdic.value(forKey: "to_address") as! String, for: .normal)
                    
                    self.contct = driverdic.value(forKey: "contact_number") as! String
                    
                    UserDefaults.standard.set(driverdic.value(forKey: "profile_pic") as! String, forKey: "DriverImg")
                    UserDefaults.standard.set(self.lblusername.text!, forKey: "Drivername")
                    UserDefaults.standard.synchronize()
                    
                    self.userpic.sd_setImage(with: URL(string: driverdic.value(forKey: "profile_pic") as! String), placeholderImage: UIImage(named: "default-user"))

                    var imageview = UIImageView()
                    imageview.sd_setImage(with: URL(string:UserDefaults.standard.value(forKey:"DriverImg") as! String), placeholderImage: UIImage(named: "default-user"))
                    
                    if(imageview.image != nil)
                    {
                        SANotificationView.showSABanner(title: UserDefaults.standard.value(forKey: "Drivername") as! String, message: "Driver assigned", image: imageview.image!,  showTime: 5)
                        
                    }
                    
                }else{
                    
                    let alert = UIAlertController(title: nil, message: dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                break
            case .failure(_):
                WebServiceClass().dismissprogress()

                print(response.result.error ?? "")
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
    
    // MARK: - IBaction Mehtods
    
  
    func caceltrip()
    {
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

            let ID:Int? = Int(tripid) // firstText is UITextField
            
            print(ID!)
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            let parameters = [
                "request_id" : reqid
                ] as [String : Any]
            
            Alamofire.request(WebServiceClass().BaseURL+"user/cancle/request", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    WebServiceClass().dismissprogress()

                    let dic: NSDictionary =  response.result.value! as! NSDictionary
                    
                    if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                    {
                        let alert = UIAlertController(title: nil, message:"You have cancelled your trip", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title:"Ok", style:.default, handler: { (Greego) in
                            self.removeAnimate()

                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        
                         
                            
                   
                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        
                        let alert = UIAlertController(title: nil, message: "Something went wrong with to cancel trip", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    break
                case .failure(_):
                    WebServiceClass().dismissprogress()

                    print(response.result.error ?? "")
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
    
  
    
    
    // MARK: - IBaction Mehtods
    
    @IBAction func Shareaction(_ sender: Any) {
        
        let message = "Driver name :" + UserDefaults.standard.string(forKey: "Drivername")!  + "\n" +
            "Destnation :" + (lbldesname.titleLabel?.text!)!
        
        //Set the link to share.
        
        let objectsToShare = [message]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func canceltrip(_ sender: Any) {
        
        let refreshAlert = UIAlertController(title: nil, message: "Are you sure want to cancel this trip?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.caceltrip()
        }))
        
        refreshAlert.addAction(UIAlertAction(title:"No", style:.default, handler: { (Greego) in
 }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func callaction(_ sender: Any) {
        
        let phone :  String = contct
        
        if let url = NSURL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: ["":""], completionHandler: { (Bool) in
                
            })
        }
        
    }
    @objc func AcceptRequest(notification: NSNotification) {
    
    }
    
    @IBAction func chnagelocation(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
        
    }
    
    
    func shadow(view:UIView)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
