//
//  ChooseDestinatioVC.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 07/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

let SELECTED_COLOR = UIColor(red:0.00, green:0.58, blue:0.59, alpha:1.0)

protocol locationDelegate:class
{
    func sendCordsBack(source:GMSPlace, destination: GMSPlace)
    func closePlacePicker()
}

class ChooseDestinatioVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate
{
    
    @IBOutlet weak var btnSet: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var parentMapView: UIView!
    @IBOutlet weak var lblstart: UILabel!
    @IBOutlet weak var lblend: UILabel!
    
    @IBOutlet weak var viewChooseLocation: UIView!
    
    @IBOutlet weak var txtStartLocation: UITextField!
    @IBOutlet weak var txtEndLocation: UITextField!
  
    @IBOutlet weak var tblAutoComplete: UITableView!
    
    var currentTxtField = UITextField()
    
    let geocoder = GMSGeocoder()
    
    var placesClient : GMSPlacesClient?
    var resultArray  = [GMSPlace]()
    var locationManager = CLLocationManager()

    var isTxtSource = false
    var isTxtDest = false
   
    var isTxtSourceFilled = false
    var isTxtDestFilled = false
    
    weak var  locDelegate:locationDelegate?
    var sourceLocation = CLLocationCoordinate2D()
    var sourcePlace = String()
    var destPlace = String()
    var userLocation = CLLocation()
     var sourceCord = CLLocationCoordinate2D()
     var destCord = CLLocationCoordinate2D()
   


//MARK: - Delegate Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = true
        self.txtEndLocation.text = ""
        self.txtStartLocation.text = ""
//        locationManager.delegate = self
//  locationManager.startUpdatingLocation()
    
 //       mapView.delegate = self
        self.placesClient = GMSPlacesClient()
      //  txtEndLocation.delegate = self
      //  txtStartLocation.delegate = self
        tblAutoComplete.delegate = self
        tblAutoComplete.dataSource = self
        
        self.setLabelStringAttribs()
        self.setupView()
        
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json")
            {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }

//        txtStartLocation.addTarget(self, action: #selector(didChangeText(textField:txtStartLocation)), for: .editingChanged)
//        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error" , Error.self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations.last
//        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
//        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 18);
//        self.mapView.camera = camera

        self.mapView.delegate = self

        self.mapView.isMyLocationEnabled = true
//        let marker = GMSMarker(position: center)
//
//        print("Latitude :- \(userLocation!.coordinate.latitude)")
//        print("Longitude :-\(userLocation!.coordinate.longitude)")
//
//
//        marker.map = self.mapView
//        marker.title = "Current Location"
//        let location = userLocation
        let geocoder = GMSGeocoder()
//
//        let newloc = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
//
//
//        geocoder.reverseGeocodeCoordinate(newloc) { response , error in
//
//            //Add this line
//            if let address = response!.firstResult() {
//                let lines = address.lines! as [String]
//
//                self.txtStartLocation.text = lines[0] + "," + lines[1]
//            }
//        }
//        locationManager.stopUpdatingLocation()
//        self.getAddressFromGeocodeCoordinate(coordinate: newloc)
//        isTxtSource = true
//        isTxtDest = false
//        locationManager.stopUpdatingLocation()
    }
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
   
    
    @IBAction func textDidChange(_ textField: UITextField)
    {
                let currentText = textField.text ?? ""
        if currentText == "" {
            resultArray.removeAll()
            self.tblAutoComplete.reloadData()
            return
        }
                placeAutocomplete(text:currentText)
    }
   
    @IBAction func destTextDidChange(_ textField: UITextField)
    {
        let currentText = textField.text ?? ""
        if currentText == "" {
            resultArray.removeAll()
            self.tblAutoComplete.reloadData()
            return
        }
        placeAutocomplete(text:currentText)
    }
//    @objc func didChangeText(textField:UITextField)
//    {
//        let currentText = textField.text ?? ""
//        placeAutocomplete(text:currentText)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 18);
        self.mapView.camera = camera
     txtEndLocation.text = ""
        txtStartLocation.text = ""
         sourceCord.latitude = 0.0
        sourceCord.longitude = 0.0
        destCord.latitude = 0.0
        destCord.longitude = 0.0

        let geocoder = GMSGeocoder()
        
        let newloc = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        
        geocoder.reverseGeocodeCoordinate(newloc) { response , error in
            
            //Add this line
            if let address = response!.firstResult() {
                let lines = address.lines! as [String]
                
                //self.txtStartLocation.text = lines[0] + "," + lines[1]
            }
        }
        self.getAddressFromGeocodeCoordinate(coordinate: newloc)
        self.currentTxtField = txtStartLocation
        isTxtSource = true
        isTxtDest = false
       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        print("latitude " + "\(coordinate.latitude)" + " longitude " + "\(coordinate.longitude)")
        
        sourceLocation = coordinate
        
       if(isTxtSource)
       {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            //Add this line
            
            if(response != nil)
            {
            if let address = response!.firstResult() {
               
                self.txtStartLocation.text = address.lines?.first
            }
            }
        
        
        }
        getAddressFromGeocodeCoordinate(coordinate: sourceLocation)

        }
       else{
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            //Add this line
            if(response != nil)
            {
            if let address = response!.firstResult() {
                
                
                self.txtEndLocation.text = address.lines?.first
            }
            
            }
        }
        
        }
    }
    
//MARK: - User Define Methods
    
    func setLocation()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func placeAutocomplete(text:String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "US"
            
        placesClient?.autocompleteQuery(text, bounds: nil, filter: filter, callback: {(results, error) -> Void in   //unable to enter in this block
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                self.resultArray = [GMSPlace]()
                for result in results {
                    
                    // A hotel in Saigon with an attribution.
                    let placeID = result.placeID;
                    self.placesClient?.lookUpPlaceID(placeID!, callback: { (place, error) -> Void in
                        if let error = error {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let place = place else {
                            print("No place details for \(String(describing: placeID))")
                            return
                        }
                        
                        if self.resultArray.count <= 5
                        {
                            self.resultArray.append(place)
                        }
                         print("Place name \(place.name)")
                        print("Place address \(String(describing: place.formattedAddress))")
                        print("Place placeID \(place.placeID)")
                        print("Place attributions \(String(describing: place.attributions))")
                         self.tblAutoComplete.reloadData()
                    })
                    
                    print("Result \(result.attributedPrimaryText) with placeID \(String(describing: result.placeID))")
                }
            }
           
        })
    }
    
    
    func setupView()
    {
        viewChooseLocation.layer.borderColor =  UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        viewChooseLocation.layer.borderWidth = 1.0
        
        viewChooseLocation.layer.masksToBounds = false
        viewChooseLocation.layer.shadowColor = UIColor.black.cgColor
        
        viewChooseLocation.layer.shadowOpacity = 0.5
        viewChooseLocation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewChooseLocation.layer.shadowRadius = 1
        
        parentMapView.isUserInteractionEnabled = false
        parentMapView.isHidden = true
        
    }

    func setLabelStringAttribs()
    {
        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : SELECTED_COLOR]
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString1 = NSMutableAttributedString(string:"S", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"tart", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(string:"E", attributes:attrs1)
        let attributedString4 = NSMutableAttributedString(string:"nd", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        attributedString3.append(attributedString4)
        
        self.lblstart.attributedText = attributedString1
        self.lblend.attributedText = attributedString3
    }
    
    func getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            //Add this line
            if(response != nil)
            {
            if let address = response!.firstResult() {
                if self.isTxtSource == true
                {
                    self.sourceCord = coordinate
                    self.sourcePlace = (address.lines?.first)!
                    self.isTxtSourceFilled = true
                    
                }
                else
                {
                    self.destCord = coordinate
                    self.destPlace = (address.lines?.first)!
                    self.isTxtDestFilled = true

                }
                let lines = address.lines! as [String]
                
                self.currentTxtField.text = lines.first
                self.resultArray.removeAll()
                self.view.endEditing(true)
            
        //        print(lines)
                
                if self.sourceCord.latitude != 0.0 && self.sourceCord.longitude != 0.0 && self.destCord.latitude != 0.0 && self.destCord.longitude != 0.0
                {
                    self.view.endEditing(true)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DrideMapVC") as! DrideMapVC
                    vc.sourceCord = self.sourceCord
                    vc.destCord = self.destCord
                    vc.sourcePlace = self.sourcePlace
                    vc.destPlace = self.destPlace
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            
                }
            }
        }
    }
    
//MARK : IBAction Methods
    
    @IBAction func btnSetClicked(_ sender: Any)
    {
        parentMapView.isUserInteractionEnabled = false
        parentMapView.isHidden = true
        
        
       getAddressFromGeocodeCoordinate(coordinate: sourceLocation)
        
    }
    
}
extension ChooseDestinatioVC:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        if(currentText != "")
        {
        placeAutocomplete(text:currentText)
        }
        else
        {
            self.resultArray.removeAll()
            self.tblAutoComplete.reloadData()
        }
        
        return true
    }
   
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.layer.borderColor = SELECTED_COLOR.cgColor
        textField.layer.borderWidth = 1.0
        
        self.tblAutoComplete.isHidden = false
        
        self.tblAutoComplete.reloadData()
        
        if(textField == txtStartLocation)
        {
            isTxtSource = true
            isTxtDest = false
           currentTxtField = txtStartLocation
        }
        else if(textField == txtEndLocation)
        {
            isTxtSource = false
            isTxtDest = true
            currentTxtField = txtEndLocation
        }
        else
        {
            isTxtSource = false
            isTxtDest = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
     
      
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        self.tblAutoComplete.isHidden = true
        self.resultArray.removeAll()
        
    }
    
}



extension ChooseDestinatioVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setLocationCell", for: indexPath) as! setLocationCell
        if indexPath.row < resultArray.count
        {
        let place = resultArray[indexPath.row]
        cell.lblName.text = place.name
        cell.lblAddress.text = place.formattedAddress
        }
        else
        {
            cell.lblName.text = "Set location on the map"
            cell.lblAddress.text = ""
            cell.imgView.image = #imageLiteral(resourceName: "flag icon")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do something, unable to reach here
        if indexPath.row == resultArray.count
        {
            self.view.endEditing(true)
            parentMapView.isUserInteractionEnabled = true
            parentMapView.isHidden = false
            self.setLocation()
            return
        }
        let place = resultArray[indexPath.row]
        
        let cord = place.coordinate
        self.getAddressFromGeocodeCoordinate(coordinate: cord)
//        if isTxtSource
//        {
//
//       //     txtStartLocation.text = place.formattedAddress
//
//            tblAutoComplete.isHidden = true
//        }
//        else
//        {
//
//     //       txtEndLocation.text = place.formattedAddress
//        }
       
    }
//MARK : IBAction Methods
    
    @IBAction func btnBackClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
