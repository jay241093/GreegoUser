//
//  OnTripVC.swift
//  greegotaxiapp
//
//  Created by Ravi Dubey on 5/5/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SDWebImage
import MapKit
class OnTripVC: UIViewController ,GMSMapViewDelegate,CLLocationManagerDelegate{
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet var usemap: GMSMapView!
    
    
    @IBOutlet weak var lblpromocode: UIButton!
    
    
    @IBOutlet weak var lblestimatedtime: UILabel!
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var locationManager = CLLocationManager()
    var timer = Timer()
    var contct : String = ""
    var tripid : String = ""
    @IBOutlet weak var imguser: UIImageView!
    
    var Drivername : String = ""
    let sourceMarker = GMSMarker()
    let destMarker = GMSMarker()
    var driverid: NSNumber = 0
    var driverlatlong = NSDictionary()

    var destination = CLLocationCoordinate2D()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocation()
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        let reqdic : NSDictionary = driverdetaildic.value(forKey:"request") as! NSDictionary
        
        let driverdic = driverdetaildic.value(forKey: "driver") as! NSDictionary
        
        self.driverid = driverdetaildic.value(forKey: "driver_id") as! NSNumber
        let driverlocationdic : NSDictionary = driverdetaildic.value(forKey:"driver_location") as! NSDictionary
        
        let first = driverdic.value(forKey: "name") as! String
        let last = driverdic.value(forKey: "lastname") as! String
        
        self.lblname.text = first + " " + last
        self.lblpromocode.setTitle(driverdic.value(forKey:"promocode") as? String, for: .normal)
        
        let sourcelat = driverlocationdic.value(forKey: "lat") as! NSNumber
        let sourcelng = driverlocationdic.value(forKey: "lng") as! NSNumber
        
        let deslat = reqdic.value(forKey: "to_lat") as! NSNumber
        let deslng = reqdic.value(forKey: "to_lng") as! NSNumber
        var source = CLLocationCoordinate2D(latitude: sourcelat.doubleValue, longitude: sourcelng.doubleValue)
        var destination = CLLocationCoordinate2D(latitude:deslat.doubleValue, longitude: deslng.doubleValue)
        
        self.destination = destination
        self.drawPath(sourceCord: source, destCord: destination)
        
        
        NotificationCenter.default.addObserver(self, selector:  #selector(AcceptRequest), name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)

        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json")
            {
                usemap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                usemap.settings.myLocationButton = true
                usemap.isMyLocationEnabled = true
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        
        
    ///  getdriverdetail()
        let tap2 = UITapGestureRecognizer()
        tap2.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        imguser.addGestureRecognizer(tap2)
        imguser.isUserInteractionEnabled = true
        imguser.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        if let key = UserDefaults.standard.object(forKey: "profile_pic"){
            
            var profile =   UserDefaults.standard.value(forKey: "profile_pic")as! String
            
            
            var catPictureURL = NSURL(string: profile)
            
            self.imguser.sd_setImage(with: catPictureURL as! URL, placeholderImage: UIImage(named: "default-user"))
            //self.updateprofileimg.image = image
        }
        imguser.layer.borderWidth=1.0
        imguser.layer.masksToBounds = false
        imguser.layer.borderColor = UIColor.white.cgColor
        imguser.layer.cornerRadius = imguser.frame.size.height/2
        imguser.clipsToBounds = true
        usemap.delegate = self
        let tap = UITapGestureRecognizer()
        tap.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        
        usemap.isMyLocationEnabled =  true
        imguser.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setLocation()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error" , Error.self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        self.drawPath(sourceCord: center, destCord: self.destination)
        
    }
    
    
   
    
    func drawPath(sourceCord:CLLocationCoordinate2D,destCord:CLLocationCoordinate2D)
    {
        
        if AppDelegate.hasConnectivity() == true
        {
       // WebServiceClass().showprogress()

        let origin = "\(sourceCord.latitude),\(sourceCord.longitude)"
        let destination = "\(destCord.latitude),\(destCord.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyCQOE9aBk_Zzd6pmX4i394FR1xgO5nLrRk"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // HTTP URL response
            print(response.data ?? "")     // server data
            print(response.result)   // result of response serialization
            do {
               // WebServiceClass().dismissprogress()
                let json = try JSON(data: response.data!)
                
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 5.0
                    polyline.strokeColor = UIColor.black
                    self.usemap.clear()
                    polyline.map = self.usemap
                    
                    
                    let legs = route["legs"]
                    
                    let firstLeg = legs[0]
                    let firstLegDurationDict = firstLeg["duration"]
                    let firstLegDuration = firstLegDurationDict["text"]
                    
                    let firstLegDistanceDict = firstLeg["distance"]
                    let firstLegDistance = firstLegDistanceDict["text"]
                    
                    self.lblestimatedtime.text = String(describing: firstLegDuration)

                    
                    var bounds = GMSCoordinateBounds()
                    
                    bounds = bounds.includingCoordinate(sourceCord)
                    bounds = bounds.includingCoordinate(destCord)
                    let update = GMSCameraUpdate.fit(bounds, withPadding: 140)
                    self.usemap.animate(with: update)
                    //self.usemap.animate(with: GMSCameraUpdate.fit(bounds))

                    self.sourceMarker.icon = UIImage(named:"user1")
                    self.sourceMarker.position = CLLocationCoordinate2D(latitude: sourceCord.latitude, longitude:sourceCord.longitude)
                    self.sourceMarker.map = self.usemap
                    
                    
                    self.destMarker.icon = UIImage(named:"pinview")
                    
                    self.destMarker.position = CLLocationCoordinate2D(latitude:destCord.latitude, longitude: destCord.longitude)
                    self.destMarker.map = self.usemap
                    
                   if(sourceCord.latitude == destCord.latitude)
                   {
                    
                    self.timer.invalidate()
                    }
                    else
                   {
                    self.scheduledTimerWithTimeInterval()
                    }
                }
            }
            catch _ {
              //  WebServiceClass().dismissprogress()

                // Error handling
            }
            
            //            if (PFUser.currentUser() != nil) {
            //                return true
            //            }
        }
        }
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
       // timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(getDrivers), userInfo: nil, repeats: true)
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
                        let newdic : NSDictionary =  dic.value(forKey: "data") as! NSDictionary
                        let reqdic : NSDictionary = newdic.value(forKey:"request") as! NSDictionary

                        let driverdic = newdic.value(forKey: "driver") as! NSDictionary
                        
                        self.driverid = newdic.value(forKey: "driver_id") as! NSNumber
                        let driverlocationdic : NSDictionary = newdic.value(forKey:"driver_location") as! NSDictionary

                        let first = driverdic.value(forKey: "name") as! String
                        let last = driverdic.value(forKey: "lastname") as! String
                        
                        self.lblname.text = first + " " + last
                        self.lblpromocode.setTitle(driverdic.value(forKey:"promocode") as? String, for: .normal)

                        let sourcelat = driverlocationdic.value(forKey: "lat") as! NSNumber
                        let sourcelng = driverlocationdic.value(forKey: "lng") as! NSNumber

                        let deslat = reqdic.value(forKey: "to_lat") as! NSNumber
                        let deslng = reqdic.value(forKey: "to_lng") as! NSNumber
                        var source = CLLocationCoordinate2D(latitude: sourcelat.doubleValue, longitude: sourcelng.doubleValue)
                        var destination = CLLocationCoordinate2D(latitude:deslat.doubleValue, longitude: deslng.doubleValue)

                        self.destination = destination
                        self.drawPath(sourceCord: source, destCord: destination)
                        
                        
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
    
    @objc func getDrivers()
    {
        if AppDelegate.hasConnectivity() == true
        {
            
           // WebServiceClass().showprogress()
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            let parameters = [
                "lat" : UserDefaults.standard.value(forKey: "Latitude")!,
                "lng" : UserDefaults.standard.value(forKey: "Longitude")!
                
                ] as [String : Any]
            
            Alamofire.request(WebServiceClass().BaseURL+"user/get/drivers", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                   // WebServiceClass().dismissprogress()
                    if response.result.value != nil{
                      //  print(response.result.value!)
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            let dic: NSDictionary =  response.result.value! as! NSDictionary
                            let data = dic.value(forKey: "data") as! NSArray

                           
                           if(data.count > 0)
                           {
                            for var i in 0...data.count-1
                            {
                                let dic : NSDictionary = data[i] as! NSDictionary
                                
                                if(self.driverid == dic.value(forKey: "driver_id") as! NSNumber)
                                {
                                    
                                    self.driverlatlong = dic
                                    
                                    
                                }
                                
                            }
                         if(self.driverlatlong != nil)
                         {
                            let sourclat = self.driverlatlong.value(forKey: "lat") as! NSNumber
                            let sourclng = self.driverlatlong.value(forKey: "lng") as! NSNumber
                            var source = CLLocationCoordinate2D(latitude: sourclat.doubleValue, longitude: sourclng.doubleValue)
                            self.drawPath(sourceCord: source, destCord: self.destination)
                            }
                            }
                           
                        }else{
                            let alert = UIAlertController(title: nil, message: dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
                    }
                    break
                    
                case .failure(_):
                   // WebServiceClass().dismissprogress()
                    
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
    @objc func AcceptRequest(notification: NSNotification) {
        WebServiceClass().dismissprogress()
        
        let object = notification.object as! NSDictionary
        
        if let key = object.object(forKey: "payment_status")
        {
            if(object.value(forKey: "payment_status") as! String == "1")
            {

                
                
            }
            
            
            
        }
            
            
        else{
            
            if let key = object.object(forKey: "status")
            {
                
                var num = object.value(forKey: "status") as! String
                if(num == "2")
                {

                    
                }
                if(num == "3")
                {
                }
                    
                else if(num == "4")
                {
                  
                    self.timer.invalidate()
                    self.locationManager.stopUpdatingLocation()
                    let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "TipViewController") as! TipViewController
                    
                    
                    let tripid : String = (object.value(forKey:"trip_id") as? String)!
                    let fees = object.value(forKey: "trip_amount") as! String
                    
                    print(fees)
                    popOverConfirmVC.amount = fees
                    popOverConfirmVC.tripid =  tripid
                    self.addChildViewController(popOverConfirmVC)
                    popOverConfirmVC.view.frame = self.view.frame
                    self.view.center = popOverConfirmVC.view.center
                    self.view.addSubview(popOverConfirmVC.view)
                    popOverConfirmVC.didMove(toParentViewController: self)
                    
                    
                }
                else if(num == "5")
                {
              
                    
                }
                else
                {
                    
                    
                }
                
            }
            else
            {
          
                
            }
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
