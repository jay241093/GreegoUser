//
//  MainmapViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 03/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class MainmapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate, locationDelegate, UIGestureRecognizerDelegate
{
    @IBOutlet weak var lblupdate: UILabel!
    @IBOutlet weak var btnEditVehicle: UIButton!
    @IBOutlet weak var btnChooseVehicle: UIButton!
    
    @IBOutlet weak var updateViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnUncomplete: UIButton!
    @IBOutlet weak var txtSearchPlace: UITextField!

    @IBOutlet weak var btnsidemenu: UIBarButtonItem!

    @IBOutlet weak var userimg: UIImageView!
    @IBOutlet weak var btn_sidemenu: UIButton!
    @IBOutlet weak var btnBackToHome: UIButton!
    
    @IBOutlet var viewFirstPopUp: UIView!
    @IBOutlet weak var updatePopUp: UIView!
    @IBOutlet weak var viewCarSelection: UIView!
    
    @IBOutlet weak var userMapView: GMSMapView!
    var timer = Timer()

    
    var lat = CLLocationDegrees()
    var long = CLLocationDegrees()
    var location = CLLocation()

    var locationManager = CLLocationManager()
    var isExpanded = false
    var unCompleteCount = 0
    let appColor = UIColor.init(red: 0.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblVehicle: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    
    
    @IBOutlet weak var lblFirstUnderLine: UILabel!
    @IBOutlet weak var lblSecondUnderLine: UILabel!
    @IBOutlet weak var lblThirdUnderLine: UILabel!
    
    
    
    @IBAction func selectvehicle(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UpdateprofileViewController") as! UpdateprofileViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        

        
    }
    func selectedvehicle(){
        WebServiceClass().showprogress()

        let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        
        Alamofire.request(WebServiceClass().BaseURL+"user/me", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                WebServiceClass().dismissprogress()
                if let data = response.result.value{
                    
                    
                    let dic = response.result.value as! NSDictionary
                    let data = dic.value(forKey: "data")as! NSDictionary
                    let newary = data.value(forKey: "vehicles")as! NSArray
                    if(newary.count > 0){
                        for var i in 0...newary.count-1
                        {
                            
                            let dic: NSDictionary = newary.object(at: i) as! NSDictionary
                            
                            if(dic.value(forKey: "selected") as! NSNumber == 1){
                                let year =  dic.value(forKey: "year")as! NSNumber
                                let vehiclename =  dic.value(forKey: "vehicle_name")as! String
                                let vehiclemodel =  dic.value(forKey: "vehicle_model")as! String
                                let color =  dic.value(forKey: "color")as! String
                                self.btnEditVehicle.setTitle(year.stringValue+" "+vehiclename+" "+vehiclemodel+" "+color , for: .normal)
                                
                            }
                            else{
                                
                            }
                        }
                        
                        
                    }
                    
                    //   self.vehiclemakearray = vmakearray.mutableCopy() as! NSMutableArray
                    
                    print(response.result.value!)
                }
                
            case .failure(_):
                WebServiceClass().dismissprogress()

                print("error")
            }
            
        }
    }
    //MARK: - Delegate Methods\
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(getDrivers), userInfo: nil, repeats: true)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
        scheduledTimerWithTimeInterval()
        
         let tap1 = UITapGestureRecognizer()
        tap1.addTarget(self, action: #selector(explandview))

        updatePopUp.addGestureRecognizer(tap1)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        userimg.addGestureRecognizer(tap)
        userimg.isUserInteractionEnabled = true
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: btnEditVehicle.frame.size.height - width,   width:  btnEditVehicle.frame.size.width, height: btnEditVehicle.frame.size.height)
        
        border.borderWidth = width
        btnEditVehicle.layer.addSublayer(border)
        btnEditVehicle.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.navigationBar.isHidden = true
        if let key = UserDefaults.standard.object(forKey: "profile_pic"){
            
            var profile =   UserDefaults.standard.value(forKey: "profile_pic")as! String
            
            
            var catPictureURL = NSURL(string: profile)
            
            self.userimg.sd_setImage(with: catPictureURL as! URL, placeholderImage: UIImage(named: "default-user"))
            //self.updateprofileimg.image = image
        }
        userimg.layer.borderWidth=1.0
        userimg.layer.masksToBounds = false
        userimg.layer.borderColor = UIColor.white.cgColor
        userimg.layer.cornerRadius = userimg.frame.size.height/2
        userimg.clipsToBounds = true
        
        self.setLabelTap()
        self.selectedvehicle()
//        let button = UIButton(type: UIButtonType.custom)
//
//        var image = #imageLiteral(resourceName: "forbes-profile")
//        image = image.resize()!
//        button.setImage(image, for: UIControlState.normal)
//        button.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//
//        button.frame=CGRect(x:0, y:0, width:40, height:40)
//        let barButton = UIBarButtonItem(customView: button)
//        barButton.target = revealViewController()
//        barButton.action = #selector(SWRevealViewController.revealToggle(_:))
//        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//
//        self.navigationItem.leftBarButtonItems = [barButton]
        
        
    
        
        
        
        viewCarSelection.layer.cornerRadius = 20.0
        viewCarSelection.layer.masksToBounds = true
        
        btnEditVehicle.layer.borderWidth = 1.0
        btnChooseVehicle.layer.borderWidth = 1.0
        
        btnEditVehicle.layer.borderColor = UIColor.darkGray.cgColor
        btnChooseVehicle.layer.borderColor = UIColor.darkGray.cgColor
        
        btnEditVehicle.layer.masksToBounds = true
        btnChooseVehicle.layer.masksToBounds = true
        
        userMapView.delegate = self
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json")
            {
                userMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
//
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        self.setLocation()
        self.setLeftView()
        txtSearchPlace.background = UIImage.init(named: "Rectangle 38.png")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.userMapView.bringSubview(toFront: txtSearchPlace)
        self.txtSearchPlace.isUserInteractionEnabled = true
        
        
        isExpanded = false
        updateViewHeightContraint.constant = 40.0
       // self.navigationController?.isNavigationBarHidden = false
        btnUncomplete.layer.cornerRadius = btnUncomplete.frame.size.height/2
        self.getData()

    }
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error" , Error.self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        location = locations.last!
        let userLocation = locations.last
    
        lat = (userLocation?.coordinate.latitude)!
        long = (userLocation?.coordinate.longitude)!
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 18);
        self.userMapView.camera = camera
        self.userMapView.isMyLocationEnabled = true
        self.userMapView.settings.myLocationButton = true

        
        
        
//        let marker = GMSMarker(position: center)
        
//
//        print("Latitude :- \(userLocation!.coordinate.latitude)")
//        print("Longitude :-\(userLocation!.coordinate.longitude)")
//
//        marker.map = self.userMapView
//        marker.title = "Current Location"
        
        locationManager.stopUpdatingLocation()
        getDrivers()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func closePlacePicker()
    {
        self.navigationController?.popViewController(animated: true)
    }
  
    func sendCordsBack(source:GMSPlace, destination: GMSPlace)
    {
        let sourceMarker = GMSMarker(position: source.coordinate)
        let destMarker = GMSMarker(position: destination.coordinate)
        
        sourceMarker.map = userMapView
        destMarker.map = userMapView
    }
    
//MARK: - TextField Delegate Methods

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseDestinatioVC") as! ChooseDestinatioVC
        
        vc.userLocation = location
        self.view.endEditing(true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    
    }
    
    
// MARK: - IBAction Methods
    
    @IBAction func sidemenuaction(_ sender: Any)
    {
        
        btn_sidemenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }
    
    @objc func explandview()
    {
        if isExpanded
        {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.updatePopUp.heightAnchor.constraint(equalToConstant: 40.0)
                self.updateViewHeightContraint.constant = 40.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.updatePopUp.heightAnchor.constraint(equalToConstant: 190.0)
                self.updateViewHeightContraint.constant = 190.0
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            
        }
        isExpanded = !isExpanded
        
    }
    
    @IBAction func btnExpandClicked(_ sender: Any)
    {
        if isExpanded
        {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.updatePopUp.heightAnchor.constraint(equalToConstant: 40.0)
                self.updateViewHeightContraint.constant = 40.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.updatePopUp.heightAnchor.constraint(equalToConstant: 190.0)
                self.updateViewHeightContraint.constant = 190.0
                self.view.layoutIfNeeded()
            }, completion: nil)
            
           
        }
        isExpanded = !isExpanded
    }
    
    
//MARK: - USER DEFINE FUNCTIONS
    
    func setLabelTap()
    {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.lblProfileAction(gr:)))
        lblProfile.addGestureRecognizer(tap)
        tap.delegate = self
        
        
        let tap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.lblVehicleAction(gr:)))
        lblVehicle.addGestureRecognizer(tap2)
        tap2.delegate = self
        
        let tap3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.lblPaymentAction(gr:)))
        lblPayment.addGestureRecognizer(tap3)
        tap3.delegate = self
        
        
        
    }
    @objc func lblProfileAction(gr:UITapGestureRecognizer)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateprofileViewController") as! UpdateprofileViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func lblVehicleAction(gr:UITapGestureRecognizer)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Vehicle_informationViewController") as! Vehicle_informationViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func lblPaymentAction(gr:UITapGestureRecognizer)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Paymentscreen1ViewController") as! Paymentscreen1ViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func setLocation()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func setLeftView()
    {
        txtSearchPlace.contentMode = .scaleAspectFit

        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "home"))
        imageView.frame = CGRect(x: 20, y: 0, width: 40, height: 40)
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        view.addSubview(imageView)
        txtSearchPlace.leftViewMode = UITextFieldViewMode.always
        
        txtSearchPlace.leftView = view
        txtSearchPlace.textRect(forBounds: txtSearchPlace.bounds)
        txtSearchPlace.placeholderRect(forBounds: txtSearchPlace.bounds)
        
        txtSearchPlace.attributedPlaceholder = NSAttributedString(string: "Where do you want to go?",attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
    }
    
    func setShadow()
    {
        viewFirstPopUp.layer.cornerRadius = 15.0
        viewFirstPopUp.layer.masksToBounds = true
    }
    
    func showFirstPopUp()
    {
        self.setBluerEffect()
        self.view.bringSubview(toFront: viewFirstPopUp)
        
    }
    func setBluerEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.2
        view.addSubview(blurEffectView)
    }
    func getData()
    {
        self.btnUncomplete.isHidden = false
        unCompleteCount = 0
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
                            
                            
                            let dataDic: NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            
                            
                            
                            UserDefaults.standard.set(dataDic.value(forKey:"email_verified"), forKey: "email_verified")

                            UserDefaults.standard.set(dataDic.value(forKey:"id"), forKey: "user_id")
                            UserDefaults.standard.set(dataDic.value(forKey:"created_at") as! String, forKey: "CreatedAt")
                            UserDefaults.standard.synchronize()
                            let cards = dataDic.value(forKey: "cards") as! NSArray
                            if cards.count == 0
                            {
                                self.unCompleteCount += 1
                                self.lblPayment.textColor = UIColor.red
                                self.lblThirdUnderLine.backgroundColor = UIColor.red
                            }
                            else
                            {
                                self.lblPayment.textColor = self.appColor
                                self.lblThirdUnderLine.backgroundColor = self.appColor
                            }
                            let vehicles = dataDic.value(forKey: "vehicles") as! NSArray
                            if vehicles.count == 0
                            {
                                self.unCompleteCount += 1
                                self.lblVehicle.textColor = UIColor.red
                                self.lblSecondUnderLine.backgroundColor = UIColor.red
                            }
                            else
                            {
                                self.lblVehicle.textColor = self.appColor
                                self.lblSecondUnderLine.backgroundColor = self.appColor
                            }
                            let profilePic = dataDic.value(forKey: "profile_pic") as! String
                            if profilePic  == ""
                            {
                            
                                
                          
                                self.unCompleteCount += 1
                                self.lblProfile.textColor = UIColor.red
                                self.lblFirstUnderLine.backgroundColor = UIColor.red
                            }
                            else
                            {
                                UserDefaults.standard.set(profilePic, forKey: "profile_pic")
                                UserDefaults.standard.synchronize()
                                var url = NSURL(string: profilePic)
                                self.userimg.sd_setImage(with: url as! URL, placeholderImage: UIImage(named: "default-user"))
                                self.lblProfile.textColor = self.appColor
                                self.lblFirstUnderLine.backgroundColor = self.appColor
                            }
                            
                            
                            if self.unCompleteCount == 3
                            {
                                self.updatePopUp.isHidden = false
                                self.txtSearchPlace.isEnabled = false
                                self.userimg.isHidden = false
                                self.userimg.isUserInteractionEnabled = false
                                self.btnUncomplete.setTitle("3", for: .normal)
                            }
                            else if self.unCompleteCount == 2
                            {
                                self.updatePopUp.isHidden = false
                                self.txtSearchPlace.isEnabled = false
                                self.userimg.isHidden = false
                                self.userimg.isUserInteractionEnabled = false

                                self.btnUncomplete.setTitle("2", for: .normal)
                                
                            }
                            else if self.unCompleteCount == 1
                            {
                                self.updatePopUp.isHidden = false
                                self.txtSearchPlace.isEnabled = false
                                self.userimg.isHidden = false
                                self.userimg.isUserInteractionEnabled = false

                                self.btnUncomplete.setTitle("1", for: .normal)
                            }
                            else if self.unCompleteCount == 0
                            {
                                self.userimg.isUserInteractionEnabled = true

                                self.updatePopUp.isHidden = true
                                self.txtSearchPlace.isEnabled = true
                                self.userimg.isHidden = false
                                self.btnUncomplete.setTitle("0", for: .normal)
                                self.btnUncomplete.isHidden = true
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
    @objc func getDrivers()
    {
        
        UserDefaults.standard.set(lat, forKey:"Latitude")
        UserDefaults.standard.set(long, forKey:"Longitude")
        UserDefaults.standard.synchronize()
        if AppDelegate.hasConnectivity() == true
        {
            
            //WebServiceClass().showprogress()
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            print(headers)
            print(lat)
            print(long)
            let parameters = [
                "lat" : lat,
                "lng" : long
                
                ] as [String : Any]
            
                Alamofire.request(WebServiceClass().BaseURL+"user/get/drivers", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                    
                switch(response.result) {
                case .success(_):
                  //  WebServiceClass().dismissprogress()
                    if response.result.value != nil{
                        print(response.result.value!)
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            self.userMapView.clear()
                            let dic: NSDictionary =  response.result.value! as! NSDictionary
                            let data = dic.value(forKey: "data") as! NSArray
                            for arr in data
                            {
                                let dicTmp = arr as! Dictionary<String,Any>
                                
                                if(dicTmp["driver_on"] as! NSNumber == 1)
                                {
                                let marker = GMSMarker()
                                let lat = dicTmp["lat"] as! Double
                                let lng = dicTmp["lng"] as! Double
                                marker.position = CLLocationCoordinate2DMake(lat,lng)
                                marker.title = ""
                                marker.snippet = ""
                                marker.icon = #imageLiteral(resourceName: "user1")
                                marker.map = self.userMapView
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
    
  
    
    
}
extension UIImage{
    
    func resize() -> UIImage? {
        
        let scale = 40.0 / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: 40, height: 40))
        self.draw(in: CGRect(x: 0, y: 0, width: 40, height: 40))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

