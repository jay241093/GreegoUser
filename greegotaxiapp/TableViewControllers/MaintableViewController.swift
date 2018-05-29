//
//  MaintableViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/4/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire
class MaintableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
   
    @IBOutlet weak var lblnotrip: UILabel!
    
    @IBOutlet weak var maintableview: UITableView!
    var usertriparray = NSMutableArray()
    
//MARK: - Delegate Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "baqckground")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
       
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: - TableView Delegate Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return usertriparray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 109
    }
    
    
    
    @IBAction func btnbackaction(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let dic: NSDictionary =  usertriparray.object(at: indexPath.row)as! NSDictionary
        let id =  dic.value(forKey: "created_at")as! String
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Trip_detail_ViewController") as! Trip_detail_ViewController
        
        nextViewController.tripdic = dic
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as! MainTableViewCell!
        
       let dic: NSDictionary =  usertriparray.object(at: indexPath.row)as! NSDictionary
        
         let date =  dic.value(forKey: "created_at")as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      //  dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        let date1 = dateFormatter.date(from: date)
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "MMM d, yyyy - h:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date1!)
        
        if(dic.value(forKey: "total_estimated_trip_cost") != nil){
        
      if  let amt =  dic.value(forKey: "total_estimated_trip_cost")as? NSNumber
      {
            cell?.amtlbl.text = "$"+amt.stringValue
            }
        }
        let time =  dic.value(forKey: "total_estimated_travel_time")as! NSNumber
        cell?.profilepic.layer.borderWidth=1.0
        cell?.profilepic.layer.masksToBounds = false
        cell?.profilepic.layer.borderColor = UIColor.white.cgColor
        cell?.profilepic.layer.cornerRadius = (cell?.profilepic.frame.width)!/2
        cell?.profilepic.clipsToBounds = true
        cell?.view.layer.cornerRadius = 10.0
        cell?.datelbl.text = timeStamp
        cell?.timelbl.text = time.stringValue + " minutes"
      
        var name =  dic.value(forKey:"profile_pic") as! String
        var finalstr = "http://kroslinkstech.in/greego/storage/app/" + name
        
        let url = NSURL(string: finalstr)
        cell?.profilepic.sd_setImage(with:url as! URL, placeholderImage: UIImage(named: "default-user"))
       
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let dic: NSDictionary =  usertriparray.object(at: indexPath.row)as! NSDictionary

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
            
             let  userid = UserDefaults.standard.value(forKey: "user_id") as! NSNumber
            usertriphistory(str: userid.stringValue)
       
        }
    func usertriphistory(str:String){
        
        WebServiceClass().showprogress()
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
       
        let parameters = [
            "user_id":str
            
            
            ] as [String : Any]
        Alamofire.request(WebServiceClass().BaseURL+"user/get/triphistory", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                WebServiceClass().dismissprogress()
                if let data = response.result.value{
            self.usertriparray.removeAllObjects()
          if(self.usertriparray.count == 0)
          {
            self.lblnotrip.isHidden = false
         self.maintableview.isHidden = true
            }
          else
          {
            self.lblnotrip.isHidden = true
            self.maintableview.isHidden = false
            }
            var dic = response.result.value as! NSDictionary
              let data = dic.value(forKey: "data")as! NSArray
            self.usertriparray = data.mutableCopy() as! NSMutableArray
            self.maintableview.reloadData()
            print(response.result.value!)
                }
            case .failure(_):
                
                WebServiceClass().dismissprogress()

                print(response.result.error)
                break
                
            }
            
        }
       
        
        }
        
        
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
   
    
}

