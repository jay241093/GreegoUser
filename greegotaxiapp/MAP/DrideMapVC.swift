//
//  rideMapVC.swift
//  greegotaxiapp
//
//  Created by Viper on 16/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SANotificationViews
import SDWebImage
import AVFoundation


class DrideMapVC: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var lbllast4: UILabel!
    
    var sourceCord = CLLocationCoordinate2D()
    var destCord = CLLocationCoordinate2D()
   
    var sourcePlace = String()
    var destPlace = String()
    
     var strDuration = String()
     var strDistance = String()
    var vehicleid = NSNumber()
    var selectecard = NSMutableArray()
    var reqid: String = ""
    var source = ""
    var destination = ""

    @IBOutlet weak var lblRatePrice: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var debitCardView: UIView!
    
    @IBOutlet weak var debitCardSubView: UIView!
    let sourceMarker = GMSMarker()
    let destMarker = GMSMarker()
    
    var cardnum : String = ""
    
    var tripprice : String = ""
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
      
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json")
            {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        
     
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(Cardaction))
        debitCardView.addGestureRecognizer(tap)
        debitCardView.isUserInteractionEnabled  = true
        
        NotificationCenter.default.addObserver(self, selector:  #selector(AcceptRequest), name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)

        mapView.delegate = self
        
        self.debitCardSubView.layer.borderColor = UIColor.darkGray.cgColor
        
        self.debitCardSubView.layer.borderWidth = 1.0
        
        debitCardView.layer.cornerRadius = 20.0
            debitCardView.layer.masksToBounds = true
//
//        do {
//            if let styleURL = Bundle.main.url(forResource: "GoogleMap", withExtension: "json")
//            {
//                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
//            } else {
//                print("Unable to find style.json")
//            }
//        } catch {
//            print("The style definition could not be loaded: \(error)")
//        }
    
        self.setMarkers()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func AcceptRequest(notification: NSNotification) {
    WebServiceClass().dismissprogress()

        let object = notification.object as! NSDictionary
    
      if let key = object.object(forKey: "payment_status")
      {
        if(object.value(forKey: "payment_status") as! String == "1")
        {
     
            AudioServicesPlayAlertSound(SystemSoundID(1322))

            self.debitCardView.isHidden = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverRatingVC") as! DriverRatingVC
            
            let tripid : String = (object.value(forKey:"trip_id") as? String)!
            let fees = object.value(forKey: "total_amount") as! String
            
            print(fees)
            vc.amount = fees
            vc.tripid =  tripid
            self.navigationController?.pushViewController(vc, animated: true)
            
        

        }
        
        
        
        }
        
        
      else{
        
      if let key = object.object(forKey: "status")
      {
        
        var num = object.value(forKey: "status") as! String
        if(num == "2")
        {
            
            AudioServicesPlayAlertSound(SystemSoundID(1322))

            var imageview = UIImageView()
            
            imageview.sd_setImage(with: URL(string:UserDefaults.standard.value(forKey:"DriverImg") as! String), placeholderImage: UIImage(named: "default-user"))

            if(imageview.image != nil)
            {
                SANotificationView.showSABanner(title: UserDefaults.standard.value(forKey: "Drivername") as! String, message: "Driver Ongoing", image: imageview.image!,  showTime: 5)
            }
//
//            let newdic: String = ((object.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
//
//
//            let alert = UIAlertController(title: nil, message:newdic, preferredStyle: UIAlertControllerStyle.alert)
//
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (Greego) in
//
//
//            }))
//
//            self.present(alert, animated: true, completion: nil)
            
        }
        if(num == "3")
        {
            
            var imageview = UIImageView()
            AudioServicesPlayAlertSound(SystemSoundID(1322))

            imageview.sd_setImage(with: URL(string:UserDefaults.standard.value(forKey:"DriverImg") as! String), placeholderImage: UIImage(named: "default-user"))
            if(imageview.image != nil)
            {
                SANotificationView.showSABanner(title: UserDefaults.standard.value(forKey: "Drivername") as! String, message: "Driver On trip", image: imageview.image!,  showTime: 5)
            }
                self.debitCardView.isHidden = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnTripVC") as! OnTripVC
                
                let tripid : String = (object.value(forKey:"trip_id") as? String)!
                print(tripid)
                vc.tripid =  tripid
                self.navigationController?.pushViewController(vc, animated: true)
         
        }
        
        else if(num == "4")
        {
            AudioServicesPlayAlertSound(SystemSoundID(1322))

            var imageview = UIImageView()
            
            imageview.sd_setImage(with: URL(string:UserDefaults.standard.value(forKey:"DriverImg") as! String), placeholderImage: UIImage(named: "default-user"))
            if(imageview.image != nil)
            {
                SANotificationView.showSABanner(title: UserDefaults.standard.value(forKey: "Drivername") as! String, message: "Driver has drop off you", image: imageview.image!,  showTime: 5)
            }
            
            
        }
        else if(num == "5")
        {

            AudioServicesPlayAlertSound(SystemSoundID(1322))

            
            let newdic: String = ((object.value(forKey:"aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String
            
            
            let alert = UIAlertController(title: nil, message:newdic, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (Greego) in
                
                self.debitCardView.isHidden = true
                
                self.debitCardView.isHidden = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverRatingVC") as! DriverRatingVC
                
                let tripid : String = (object.value(forKey:"trip_id") as? String)!
                
                vc.tripid =  tripid
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)


            
            
            
        }
        else
        {
           
            
        }
        
        }
        else
      {
        AudioServicesPlayAlertSound(SystemSoundID(1322))

            self.debitCardView.isHidden = true
            
            let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "DriverPopupVC") as! DriverPopupVC
            
            let tripid : String = (object.value(forKey:"trip_id") as? String)!
            print(tripid)
            popOverConfirmVC.tripid =  tripid
            
            popOverConfirmVC.reqid = self.reqid
        popOverConfirmVC.tripcost = self.tripprice
        popOverConfirmVC.cardnum = self.cardnum

        
            self.addChildViewController(popOverConfirmVC)
            popOverConfirmVC.view.frame = self.view.frame
            self.view.center = popOverConfirmVC.view.center
            self.view.addSubview(popOverConfirmVC.view)
            popOverConfirmVC.didMove(toParentViewController: self)
            
        }
        }
    }
    
    
    @IBAction func btnBackCliked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func Cardaction()
    
    {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Paymentscreen1ViewController") as! Paymentscreen1ViewController
        nextViewController.isfrom = "1"
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        

    }
    
    
    
    func setMarkers()
    {
      self.drawPath()
    }
    func drawText(text:NSString, inImage:UIImage) -> UIImage? {
    
    let font = UIFont.systemFont(ofSize: 11)
    let size = inImage.size
    
    UIGraphicsBeginImageContext(size)
    
    inImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let style : NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    style.alignment = .center
        let attributes:NSDictionary = [ NSAttributedStringKey.font : font, NSAttributedStringKey.paragraphStyle : style, NSAttributedStringKey.foregroundColor : UIColor.black ]
    
        let textSize = text.size(withAttributes: attributes as? [NSAttributedStringKey : Any])
    let rect = CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height)
    let textRect = CGRect(x: (rect.size.width - textSize.width)/2, y: (rect.size.height - textSize.height)/2 - 2, width: textSize.width, height: textSize.height)
    text.draw(in: textRect.integral, withAttributes: attributes as? [NSAttributedStringKey : Any])
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return resultImage
    }
    
    
    func drawPath()
    {
        WebServiceClass().showprogress()

        let origin = "\(sourceCord.latitude),\(sourceCord.longitude)"
        let destination = "\(destCord.latitude),\(destCord.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDuLTaJL-tMzdBoTZtCQfCz4m66iEZ1eQc"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // HTTP URL response
            print(response.data ?? "")     // server data
            print(response.result)   // result of response serialization
            do {
                WebServiceClass().dismissprogress()
                let json = try JSON(data: response.data!)
                
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    self.getDrivers()

                        self.getStateCode()
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 6.0
                    polyline.strokeColor = UIColor.black
                    polyline.map = self.mapView
                    
                    
                    let legs = route["legs"]
                    
                    let firstLeg = legs[0]
                        let firstLegDurationDict = firstLeg["duration"]
                    let firstLegDuration = firstLegDurationDict["text"]
                        self.strDuration = String(describing: firstLegDuration)
                    
                    let firstLegDistanceDict = firstLeg["distance"]
                    let firstLegDistance = firstLegDistanceDict["text"]
                    self.strDistance = String(describing: firstLegDistance)
                    
                    
                    var bounds = GMSCoordinateBounds()
                    
                    bounds = bounds.includingCoordinate(self.sourceCord)
                    bounds = bounds.includingCoordinate(self.destCord)
                    let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
                    self.mapView.animate(with: update)
                    
                    self.sourceMarker.icon = self.drawText(text:self.strDuration as NSString , inImage: #imageLiteral(resourceName: "Ellipse 12"))
                    self.sourceMarker.position = CLLocationCoordinate2D(latitude: self.sourceCord.latitude, longitude: self.sourceCord.longitude)
                    self.sourceMarker.map = self.mapView
                    var fullNameArr = self.strDuration.components(separatedBy:" ")
                    
                    var firstName: NSString = fullNameArr[0] as NSString
                    var lastName: String? = fullNameArr[1]
                    
                    let date1 = Date()

                   // let date = date1.addingTimeInterval(firstName.doubleValue)
                    let finaldate  = Calendar.current.date(byAdding: .minute, value: Int(firstName as String)!, to: date1)
                    let format = DateFormatter()
                    format.dateStyle = .none
                    format.timeStyle = .medium
                    print(format.string(from: finaldate!))
                    
//                    let time:Int? = Int(firstName) // firstText is UITextField
//
//                    let calendar = Calendar.current
//                    let date1 = Date()
//
//                    let date = calendar.date(byAdding: .minute, value:time!, to: date1)
//                    let format = DateFormatter()
//                    format.dateStyle = .none
//                    format.timeStyle = .short
//                    print(format.string(from: date!))
                    
                    self.destMarker.icon = self.drawText(text:format.string(from: finaldate!) as NSString, inImage: #imageLiteral(resourceName: "Union 3"))
                    
                    self.destMarker.position = CLLocationCoordinate2D(latitude: self.destCord.latitude, longitude: self.destCord.longitude)
                    self.destMarker.map = self.mapView
                    
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
    func getStateCode()
    {
         WebServiceClass().showprogress()
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(sourceCord.latitude),\(sourceCord.longitude)&key=AIzaSyDuLTaJL-tMzdBoTZtCQfCz4m66iEZ1eQc"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // HTTP URL response
            print(response.data ?? "")     // server data
            print(response.result)   // result of response serialization
            do {
                WebServiceClass().dismissprogress()

                let json = try JSON(data: response.data!)
                print(json)
                let location = json["results"].arrayValue
                let dicLocation = location[0].dictionaryValue
                print(location)
                let dicTmp = dicLocation["address_components"]?.arrayValue
                let stateCode = dicTmp![6].dictionaryValue
                let state = stateCode["short_name"]?.string
                print(state ?? "")
                
                self.getRate(state: state!)
                
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
    func getRate(state:String)
    {
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            let parameters = [
                "state" : state
                
                ] as [String : Any]
            
            Alamofire.request(WebServiceClass().BaseURL+"get/rates", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    WebServiceClass().dismissprogress()
                    if response.result.value != nil
                    {
                        print(response.result.value!)
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        let data = dic.value(forKey: "data")
                        self.setRate(baseFare: data as! NSDictionary)
                        
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
            WebServiceClass().dismissprogress()
            WebServiceClass().nointernetconnection()

            NSLog("No Internet Connection")
        }
    }
  
    func setRate(baseFare: NSDictionary)
    {
       
        let strDis = strDistance.components(separatedBy: " ").first as! String
        let distance = Double(strDis)
        let strDura = strDuration.components(separatedBy: " ").first as! String

        let duration = Double(strDura)
        
        let base = baseFare.value(forKey: "base_fee") as! NSNumber
        let mile = baseFare.value(forKey: "mile_fee") as! NSNumber
        let overMile = baseFare.value(forKey: "overmile_fee") as! Double
        let time = baseFare.value(forKey: "time_fee") as! Double
        
       let baseFee = Double(base)
       let mileFee = Double(mile)
       let overMileFee = Double(overMile)
       let timeFee = Double(time)

        
        var tripPrice = Double()
        if (distance! <= 10.0) {
            tripPrice = baseFee + (duration! * timeFee) + (distance! * mileFee)
        } else {
            let tmpFare = baseFee + (duration! * timeFee) + (10 * mileFee)
            tripPrice = tmpFare + ((distance! - 10) * overMileFee)
        }
        
        self.lblRatePrice.text = "$" + String(tripPrice)
        
        self.tripprice = String(tripPrice)
        print(tripPrice)
    }
    
    @IBAction func btnRequestClicked(_ sender: Any)
    {
        
        let refreshAlert = UIAlertController(title: nil, message: "Are you sure you want to go from " + source + " to " + destination , preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.requestclick()
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
     
    }
    
   func requestclick()
   {
    
    
    
    if AppDelegate.hasConnectivity() == true
    {
        WebServiceClass().showprogress()
        
        let strDis = strDistance.components(separatedBy: " ").first as! String
        let distance = Double(strDis)
        let strDura = strDuration.components(separatedBy: " ").first as! String
        
        let duration = Double(strDura)
        
        let strSourceLat = String(sourceCord.latitude)
        let strsourceLng = String(sourceCord.longitude)
        
        let strDestLat = String(destCord.latitude)
        let strDestLng = String(destCord.longitude)
        
        let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        let parameters = [
            "user_vehicle_id" : self.vehicleid,
            "from_address" : self.sourcePlace,
            "from_lat" : strSourceLat,
            "from_lng" : strsourceLng,
            "to_address" : self.destPlace,
            "to_lat" : strDestLat,
            "to_lng" : strDestLng,
            "total_estimated_travel_time" : self.strDuration,
            "total_estimated_trip_cost" : tripprice
            ] as [String : Any]
        
        Alamofire.request(WebServiceClass().BaseURL+"user/add/request", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
            case .success(_):
                WebServiceClass().dismissprogress()
                let dic: NSDictionary =  response.result.value! as! NSDictionary
                
                if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                {
                    print(response.result.value!)
                    
                    let dic: NSDictionary = response.result.value! as! NSDictionary
                    
                    let newdic: NSDictionary = dic.value(forKey: "data") as! NSDictionary
                    
                    
                    let req = newdic.value(forKey:"id") as! NSNumber
                    
                    self.reqid = req.stringValue

                    let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
                    self.addChildViewController(popOverConfirmVC)
                    popOverConfirmVC.view.frame = self.view.frame
                    self.view.center = popOverConfirmVC.view.center
                    self.view.addSubview(popOverConfirmVC.view)
                    popOverConfirmVC.didMove(toParentViewController: self)
                 //WebServiceClass().showwithimage()
                    
                    
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
    
    
    
    func getDrivers()
    {
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            let parameters = [
                "lat" : sourceCord.latitude,
                "lng" : sourceCord.longitude
              
                ] as [String : Any]
            
            Alamofire.request(WebServiceClass().BaseURL+"user/get/drivers", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    WebServiceClass().dismissprogress()

                    if response.result.value != nil{
                        print(response.result.value!)
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                   let dic: NSDictionary =  response.result.value! as! NSDictionary
                        let data = dic.value(forKey: "data") as! NSArray
                        for arr in data
                        {
                            let dicTmp = arr as! Dictionary<String,Any>
                            let marker = GMSMarker()
                            let lat = dicTmp["lat"] as! Double
                            let lng = dicTmp["lng"] as! Double
                            marker.position = CLLocationCoordinate2D(latitude: lat , longitude: lng )
                            marker.title = ""
                            marker.snippet = ""
                            marker.icon = #imageLiteral(resourceName: "user1")
                            marker.map = self.mapView
                            print(dic)
                        }
                        }else{
                            let alert = UIAlertController(title: nil, message: dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
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
    
    func getData()
    {
       
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()
            
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            
            
            Alamofire.request(WebServiceClass().BaseURL+"user/me", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value!)
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                         
                            let geocoder = GMSGeocoder()
                            geocoder.reverseGeocodeCoordinate(self.sourceCord) { response , error in
                                
                                //Add this line
                                if let address = response!.firstResult() {
                                    
                                    
                                    self.source = (address.lines?.first)!
                                }
                                
                                
                            }
                            geocoder.reverseGeocodeCoordinate(self.destCord) { response , error in
                                
                                //Add this line
                                if let address = response!.firstResult() {
                                    
                                    
                                    self.destination = (address.lines?.first)!
                                }
                                
                                
                            }
                            
                            
                            
                            
                            let dataDic: NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            
                            UserDefaults.standard.set(dataDic.value(forKey:"created_at") as! String, forKey: "CreatedAt")
                            UserDefaults.standard.synchronize()
                            
                            let cards = dataDic.value(forKey: "cards") as! NSArray
                            if cards.count == 0
                            {
                           
                             
                            }
                            else
                            {
                                
                                for var i in 0...cards.count-1
                                {
                                
                                    let dic: NSDictionary = cards.object(at: i) as! NSDictionary
                               if(dic.value(forKey:"selected") as! NSNumber == 1)
                               {
                                let decodedData = Data(base64Encoded: dic.value(forKey: "card_number")as! String)!
                                let decodedString = String(data: decodedData, encoding: .utf8)!
                                  self.selectecard.add(decodedString)
                                }
                            }
                           if(self.selectecard.count == 0)
                           {
                            let refreshAlert = UIAlertController(title: nil, message: "You have not Slelected any card please select any card to continue.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Paymentscreen1ViewController") as! Paymentscreen1ViewController
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                                
                                
                            }))
                            
                         
                            self.present(refreshAlert, animated: true, completion: nil)
                            
                            }
                            else
                           {
                            
                            let str = self.selectecard.object(at: 0) as! String
                            let last4 = String(str.characters.suffix(4))

                            self.lbllast4.text = last4
                          self.cardnum = last4
                            
                                }
                                
                            }
                            let vehicles = dataDic.value(forKey: "vehicles") as! NSArray
                            if vehicles.count == 0
                            {
                                
                            }
                            else
                            {
                                for var i in 0...vehicles.count-1
                                {
                                    let dic: NSDictionary = vehicles[i] as! NSDictionary
                                    
                                    if(dic.value(forKey: "selected") as! NSNumber  == 1)
                                    {
                                        self.vehicleid = dic.value(forKey:"id") as! NSNumber
                                    }
                                    
                                }
                                
                            }
                            let profilePic = dataDic.value(forKey: "profile_pic") as! String
                            if profilePic  == "null"
                            {
                              
                            }
                            else
                            {
                              
                            }
                            
                            
                        
                        }
                        
                        WebServiceClass().dismissprogress()

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
