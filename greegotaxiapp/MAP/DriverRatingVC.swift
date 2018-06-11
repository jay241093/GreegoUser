//
//  DriverRatingVC.swift
//  MyGreegoApp
//
//  Created by Pish Selarka on 20/04/18.
//  Copyright © 2018 Techrevere. All rights reserved.
//

import UIKit
import FloatRatingView
import SDWebImage
import Alamofire

class DriverRatingVC: UIViewController,FloatRatingViewDelegate{
    
    var amount = ""

    @IBOutlet weak var lbldrivername: UILabel!
    
    @IBOutlet weak var innerview: UIView!
    
    var tripid : String = ""
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRatingText: UILabel!
   
    @IBOutlet weak var lbldes: UILabel!
    
    @IBOutlet weak var imgdriver: UIImageView!
    @IBOutlet weak var lblamount: UILabel!
    
    var ratingnew: String = ""
    
    @IBOutlet weak var btnsubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getdriverdetail()
        imgdriver.layer.borderWidth = 1
        imgdriver.layer.masksToBounds = false
        imgdriver.layer.cornerRadius = imgdriver.frame.height/2
        imgdriver.clipsToBounds = true

        innerview.layer.cornerRadius = 8.0
        
        btnsubmit.layer.cornerRadius = 8.0
        
       
        
    lblamount.text = "$ " +  amount
        
    ratingView.delegate = self
        
    ratingnew = "5.0"
    }
    
    
    //MARK:- Rating Delegate
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
ratingnew = String(format: "%.2f", rating)
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
                      //  print(response.result.value!)
                        let newdic : NSDictionary =  dic.value(forKey: "data") as! NSDictionary
                        
                        let driverdic = newdic.value(forKey: "driver") as! NSDictionary
                        
                        let first = driverdic.value(forKey: "name") as! String
                        let last = driverdic.value(forKey: "lastname") as! String
                        
                        self.lbldrivername.text = "How was your trip with " + first + " " + last + "?"
                        
                        let reqdic: NSDictionary = newdic.value(forKey:"request") as! NSDictionary
                        self.lbldes.text = reqdic.value(forKey: "to_address") as! String
                        
                        self.imgdriver.sd_setImage(with: URL(string: driverdic.value(forKey: "profile_pic") as! String), placeholderImage: UIImage(named: "default-user"))
                        
                        let price =  reqdic.value(forKey:"total_estimated_trip_cost") as! NSNumber
                        
                    }else{
                        
                        let alert = UIAlertController(title: nil, message: dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    break
                case .failure(_):
                    WebServiceClass().dismissprogress()

                  //  print(response.result.error ?? "")
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
    
    func RateDriver()
    {
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

            let ID:Int? = Int(tripid) // firstText is UITextField
            let rate:Int? = Int(ratingnew) // firstText is UITextField

            print(ID!)
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            let parameters = [
                "trip_id" : ID!,
                "rating" : ratingnew
                ] as [String : Any]
            
            Alamofire.request(WebServiceClass().BaseURL+"user/add/driverrating", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    WebServiceClass().dismissprogress()

                   // print(response.result.value! )
                    let dic: NSDictionary =  response.result.value! as! NSDictionary
                    
                    if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                    {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                    }else{
                       
                        
                    }
                    
                    break
                case .failure(_):
                    WebServiceClass().dismissprogress()

                  //  print(response.result.error ?? "")
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
    
    @IBAction func btnBackClicked(_ sender: Any)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    @IBAction func Submitaction(_ sender: Any) {
        
        RateDriver()
    }
    
    
}


