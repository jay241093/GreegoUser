//
//  TermandconditionVC.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 11/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import  Alamofire
import CTCheckbox
class TermandconditionVC: UIViewController,UIScrollViewDelegate{

    @IBOutlet weak var txtview: UITextView!
    
    var ischecked:String = "0"
    var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var cb: CTCheckbox!
    
    @IBOutlet weak var lblagree: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gettermscondition()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Scrollview delegate Mehtods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // moved to top
            
            cb.isHidden = false
            lblagree.isHidden = false
            
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            cb.isHidden = true
            lblagree.isHidden = true
            
            // moved to bottom
        } else {
            // didn't move
        }
    }
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    //MARK: - IBAction Methods

    @IBAction func nextaction(_ sender: Any) {
        
        if(ischecked == "0")
        
        {
            let alert = UIAlertController(title: "Greego", message: "Please Accept Term and condition", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
       else
        {
        getuserprofile()
        
        }
        
        
    }
    
    
    @IBAction func checkbox(_ sender: CTCheckbox) {
        
        if(ischecked == "0")
        {
        ischecked = "1"
        }
        else
        {
            ischecked = "0"

            
        }
        
        
    }
    
    
func gettermscondition()
{
    
    if AppDelegate.hasConnectivity() == true
    {
        WebServiceClass().showprogress()
        
  
        Alamofire.request(WebServiceClass().BaseURL+"get/texts", method:.get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value!)
                    
                    
                    WebServiceClass().dismissprogress()
                    
                    let dic: NSDictionary =  response.result.value! as! NSDictionary
                    
                    if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                    {
                        
                        let newdic: NSDictionary = dic.value(forKey:"data") as! NSDictionary
                        let text = newdic.value(forKey:"terms_conditions") as! String
                        let htmlData = NSString(string: text).data(using: String.Encoding.unicode.rawValue)
                        
                        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                        
                        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
                        
                        self.txtview.attributedText = attributedString
                        
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
    
    
//MARK: - USER DEFINE FUNCTIONS
    
func getuserprofile()
    {
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

       
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            let parameters = [
                "name":UserDefaults.standard.value(forKey: "fname") as! String,
                "email": UserDefaults.standard.value(forKey: "email") as! String,
                "lastname":UserDefaults.standard.value(forKey: "lname") as! String,
                "city": "",
                "profile_pic":"",
                "is_agreed": ischecked,
                
            ]
            
            
            Alamofire.request(WebServiceClass().BaseURL+"user/update", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(response.result.value!)
                        
                        
                        WebServiceClass().dismissprogress()
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            UserDefaults.standard.set("1", forKey: "islogin")
                            UserDefaults.standard.synchronize()
                            
                            let newdic: NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            
                        
                                
                         
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                                
                                
                          
                            
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
    
    @IBAction func btnBackClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
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
