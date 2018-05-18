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

class MainmapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var updateViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnBackToHome: UIButton!
    @IBOutlet var viewFirstPopUp: UIView!
    @IBOutlet weak var txtSearchPlace: UITextField!
    
    @IBOutlet weak var updatePopUp: UIView!
    @IBOutlet weak var btn_sidemenu: UIButton!
    @IBOutlet weak var btnsidemenu: UIBarButtonItem!
    @IBOutlet weak var userMapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var isExpanded = false
    
    
    //MARK: - Delegate Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if revealViewController() != nil
        {
            btnsidemenu.target = revealViewController()
            //menuButton.action = "revealToggle:"
            btnsidemenu.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
          //  viewFirstPopUp.isHidden = true
          //  self.setShadow()
         //   self.showFirstPopUp()
            
            self.setLocation()
            self.setLeftView()
        
            self.userMapView.bringSubview(toFront: txtSearchPlace)
            self.txtSearchPlace.isUserInteractionEnabled = true
            
          
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        isExpanded = false
        updateViewHeightContraint.constant = 40.0
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" , Error.self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 15);
        self.userMapView.camera = camera
        self.userMapView.isMyLocationEnabled = true
        
        let marker = GMSMarker(position: center)
        
        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        marker.map = self.userMapView
        
        marker.title = "Current Location"
        locationManager.stopUpdatingLocation()
    }
    // MARK: - IBAction Methods
    
    
    @IBAction func sidemenuaction(_ sender: Any) {
        
        btn_sidemenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - IBAction Methods
    
    @IBAction func btnExpandClicked(_ sender: Any)
    {
      if isExpanded
      {
        updatePopUp.heightAnchor.constraint(equalToConstant: 40.0)
            updateViewHeightContraint.constant = 40.0
      }
        else
      {
        updatePopUp.heightAnchor.constraint(equalToConstant: 190.0)
        updateViewHeightContraint.constant = 190.0
       }
        isExpanded = !isExpanded
        
    }
    
    
    
    
    //MARK: - USER DEFINE FUNCTIONS
    
    
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
        txtSearchPlace.contentMode = .scaleToFill
        
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "photo-camera"))
        imageView.frame = CGRect(x: 0, y: 0, width: txtSearchPlace.frame.size.height-10, height: txtSearchPlace.frame.size.height-10)
        
        txtSearchPlace.leftViewMode = UITextFieldViewMode.always
        
        //txtSearchPlace.addSubview(imageView)
        txtSearchPlace.leftView = imageView
        txtSearchPlace.textRect(forBounds: txtSearchPlace.bounds)
        txtSearchPlace.placeholderRect(forBounds: txtSearchPlace.bounds)
    }
    
    func setShadow()
    {
        viewFirstPopUp.layer.cornerRadius = 15.0
        viewFirstPopUp.layer.masksToBounds = true
      
//        // Shadow and Radius
//        btnBackToHome.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
//        btnBackToHome.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        btnBackToHome.layer.shadowOpacity = 1.0
//        btnBackToHome.layer.shadowRadius = 1.0
//        btnBackToHome.layer.masksToBounds = false
//        btnBackToHome.layer.cornerRadius = 4.0
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 5);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
