//
//  Trip_detail_ViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/4/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SDWebImage

class Trip_detail_ViewController: UIViewController {

    
    @IBOutlet weak var lbltripprice: UILabel!
    
    @IBOutlet weak var lblfinaltripprice: UILabel!
    
    
    @IBOutlet weak var lblpromocode: UILabel!
    
    
    @IBOutlet weak var lbldistance: UILabel!
    
    
    @IBOutlet weak var lblcost: UILabel!
    
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblSadd: UILabel!
    
    @IBOutlet weak var lblEadd: UILabel!
    let sourceMarker = GMSMarker()
    let destMarker = GMSMarker()
    
    @IBOutlet weak var gmsmapview: GMSMapView!
    
    @IBOutlet weak var userimg: UIImageView!
    
    
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var secondview: UIView!
    @IBOutlet weak var thirdview: UIView!
    @IBOutlet weak var mapshadowview: UIView!

    @IBOutlet weak var firstimg: UIImageView!

    @IBOutlet weak var btnshadow: UIButton!
    
    @IBOutlet weak var firstlbl: UILabel!
    @IBOutlet weak var endlbl: UILabel!
   
    var tripdic = NSDictionary()
//MARK: - Delegate Methods

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
     print(tripdic)
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json")
            {
                gmsmapview.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        
        lblpromocode.text = tripdic.value(forKey:"promocode") as? String
   if  let rate = tripdic.value(forKey:"total_estimated_trip_cost") as? Double
        
   {     lblcost.text =  "$ "+String(format:"%.2f", rate)
        
    lbltripprice.text = "$ "+String(format:"%.2f", rate)
    
    lblfinaltripprice.text = "$ "+String(format:"%.2f", rate)
        }
        lbldate.text = tripdic.value(forKey:"updated_at") as! String
        var name =  tripdic.value(forKey:"profile_pic") as! String
        var finalstr = "http://kroslinkstech.in/greego/storage/app/" + name
        
        let url = NSURL(string: finalstr)
        userimg.sd_setImage(with:url as! URL, placeholderImage: UIImage(named: "default-user"))
        userimg.layer.borderWidth=1.0
        userimg.layer.masksToBounds = false
        userimg.layer.borderColor = UIColor.white.cgColor
        userimg.layer.cornerRadius = userimg.frame.size.height/2
        userimg.clipsToBounds = true
        
        lblSadd.text = tripdic.value(forKey: "from_address") as! String
        lblEadd.text = tripdic.value(forKey: "to_address") as! String
        let sourcelat = tripdic.value(forKey: "from_lat") as! NSNumber
        let sourcelng = tripdic.value(forKey: "from_lng") as! NSNumber
        
        let deslat = tripdic.value(forKey: "to_lat") as! NSNumber
        let deslng = tripdic.value(forKey: "to_lng") as! NSNumber
        var source = CLLocationCoordinate2D(latitude: sourcelat.doubleValue, longitude: sourcelng.doubleValue)
        var destination = CLLocationCoordinate2D(latitude:deslat.doubleValue, longitude: deslng.doubleValue)
        
        self.drawPath(sourceCord: source, destCord: destination)
        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor(red:0.00, green:0.58, blue:0.59, alpha:1.0)]
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString1 = NSMutableAttributedString(string:"S", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"tart", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(string:"E", attributes:attrs1)
        let attributedString4 = NSMutableAttributedString(string:"nd", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        attributedString3.append(attributedString4)
        
        self.firstlbl.attributedText = attributedString1
        self.endlbl.attributedText = attributedString3
     
        
        self.setShadow(view: mainview)
        self.setShadow(view: secondview)
        self.setShadow(view: thirdview)
        self.setShadow(view: mapshadowview)
        self.setShadow(view: btnshadow)


    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func drawPath(sourceCord:CLLocationCoordinate2D,destCord:CLLocationCoordinate2D)
    {
        
        if AppDelegate.hasConnectivity() == true
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
                        let routeOverviewPolyline = route["overview_polyline"].dictionary
                        let points = routeOverviewPolyline?["points"]?.stringValue
                        let path = GMSPath.init(fromEncodedPath: points!)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeWidth = 4.0
                        polyline.strokeColor = UIColor.black
                        polyline.map = self.gmsmapview
                        
                        
                        let legs = route["legs"]
                        
                        let firstLeg = legs[0]
                        let firstLegDurationDict = firstLeg["duration"]
                        let firstLegDuration = firstLegDurationDict["text"]
                        
                        let firstLegDistanceDict = firstLeg["distance"]
                        let firstLegDistance = firstLegDistanceDict["text"]
                        
                        
                        var bounds = GMSCoordinateBounds()
                        
                        bounds = bounds.includingCoordinate(sourceCord)
                        bounds = bounds.includingCoordinate(destCord)
                        let update = GMSCameraUpdate.fit(bounds, withPadding: 20)
                        self.gmsmapview.animate(with: update)
                        
                        self.sourceMarker.icon = #imageLiteral(resourceName: "Start-pin.png")
                        self.sourceMarker.position = CLLocationCoordinate2D(latitude: sourceCord.latitude, longitude:sourceCord.longitude)
                        self.sourceMarker.map = self.gmsmapview
                        
                        
                        self.destMarker.icon = #imageLiteral(resourceName: "Start-pin.png")
                        
                        self.destMarker.position = CLLocationCoordinate2D(latitude:destCord.latitude, longitude: destCord.longitude)
                        self.destMarker.map = self.gmsmapview
                        
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
    }
    
//MARK: - User Define Methods
    
    func setShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        view.layer.shadowRadius = 2
    }

}
