//
//  addMobileVC.swift
//  greegotaxiapp
//
//  Created by mac on 06/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import SwiftyJSON
class addMobileVC: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate
{
    @IBOutlet weak var txtMobileNum: UITextField!
    
    var  locationManager = CLLocationManager()
    var sourceCord = CLLocation()

//MARK: - Delegate Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     

        if((UserDefaults.standard.object(forKey: "Country")) != nil)
        {
             txtMobileNum.isEnabled = false
            showalert()
        }
        else
        {

            setLocation()
        }
        txtMobileNum.becomeFirstResponder()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
      txtMobileNum.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if((UserDefaults.standard.object(forKey: "Country")) != nil)
        {
            
            showalert()
        }
        else
        {
            setLocation()
        }
    }
    
    //MARK: - user define Methods
    func setLocation()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func showalert()
    {
        let alertController = UIAlertController(title: nil, message: "Exception : Please contact technical support", preferredStyle: .alert)
       
        let openAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                   to: UIApplication.shared, for: nil)
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied){
            showLocationDisabledpopUp()
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error" , Error.self)
    }
    
    var isupdated = 0
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let userLocation = locations.last
        sourceCord = locations.last!
        
       var lat = (userLocation?.coordinate.latitude)!
       var long = (userLocation?.coordinate.longitude)!
      
        getStateCode()
        locationManager.stopUpdatingLocation()
      
    }
    func showLocationDisabledpopUp() {
        let alertController = UIAlertController(title: "Background Location Access  Disabled", message: "We need your location", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Setting", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func getStateCode()
    {
        WebServiceClass().showprogress()
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(sourceCord.coordinate.latitude),\(sourceCord.coordinate.longitude)&key=AIzaSyCQOE9aBk_Zzd6pmX4i394FR1xgO5nLrRk"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // HTTP URL response
            print(response.data ?? "")     // server data
            print(response.result)   // result of response serialization
            do {
                WebServiceClass().dismissprogress()
                
                let json = try JSON(data: response.data!)
                let location = json["results"].arrayValue
                
                let dicLocation = location[0].dictionaryValue
                let dicTmp = dicLocation["address_components"]?.arrayValue
                print(dicTmp)

                let stateCode = dicTmp![(dicTmp?.count)!-1].dictionaryValue
            if  let state = stateCode["long_name"]?.string
            {
                print(state)
            
                
                if(state == "North Korea")
                {
                    self.txtMobileNum.isEnabled = false
                    UserDefaults.standard.set(state, forKey:"Country")
                    UserDefaults.standard.synchronize()
                    self.showalert()
                }
                if(state == "South Korea")
                {
                     self.txtMobileNum.isEnabled = false
                    UserDefaults.standard.set(state, forKey:"Country")
                    UserDefaults.standard.synchronize()
                    self.showalert()
                }
            }
                let stateCode1 = dicTmp![(dicTmp?.count)!-2].dictionaryValue
                if  let state1 = stateCode1["long_name"]?.string
                {
                    print(state1)
                    
                    
                    if(state1 == "North Korea")
                    {
                         self.txtMobileNum.isEnabled = false
                        UserDefaults.standard.set(state1, forKey:"Country")
                        UserDefaults.standard.synchronize()
                        self.showalert()
                    }
                    if(state1 == "South Korea")
                    {
                         self.txtMobileNum.isEnabled = false
                        UserDefaults.standard.set(state1, forKey:"Country")
                        UserDefaults.standard.synchronize()
                        self.showalert()
                    }
                }
                
                
            }
            catch _ {
                WebServiceClass().dismissprogress()
                
                // Error handling
            }
            
            //            if (PFUser.currentUser() != nil) {
            //                return true
            //            }
        }
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
      //  print( UserDefaults.standard.value(forKey: "Token") as! String)
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
                   // print(response.result.value!)
                    
                    
                    
                    
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
