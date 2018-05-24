//
//  UpdateprofileViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/5/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class UpdateprofileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    var vehiclearray = NSMutableArray()
    var selectarray = NSMutableArray()
    // var vehiclemakearray = NSMutableArray()
    @IBOutlet weak var maintableview: UITableView!
    
    @IBOutlet weak var tablevieheight: NSLayoutConstraint!
    @IBOutlet weak var firstsection: UIView!
    @IBOutlet weak var secondsection: UIView!
    @IBOutlet weak var thirdsection: UIView!
    @IBOutlet weak var forthsection: UIView!
    @IBOutlet weak var fifthsection: UIView!
    @IBOutlet weak var sixthsection: UIView!
    
    @IBOutlet weak var btnview: UIView!
    
    @IBOutlet weak var updateprofileimg: UIImageView!
    
    @IBOutlet weak var updatebtn: UIButton!
    
    @IBOutlet weak var txtfname: UITextField!
    
    @IBOutlet weak var txtlname: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        updateprofileimg.addGestureRecognizer(tapGesture)
        updateprofileimg.isUserInteractionEnabled = true
        
        let  firstname = UserDefaults.standard.value(forKey: "fname") as! String
        let  lastname = UserDefaults.standard.value(forKey: "lname") as! String
        
        txtfname.text = firstname
        txtlname.text = lastname
        self.navigationController?.navigationBar.isHidden = true
        updateprofileimg.layer.borderWidth=1.0
        updateprofileimg.layer.masksToBounds = false
        updateprofileimg.layer.borderColor = UIColor.white.cgColor
        updateprofileimg.layer.cornerRadius = updateprofileimg.frame.size.height/2
        updateprofileimg.clipsToBounds = true
        
        self.setShadow(view: firstsection)
        self.setShadow(view: secondsection)
        self.setShadow(view: thirdsection)
        self.setShadow(view: forthsection)
        self.setShadow(view: fifthsection)
        self.setShadow(view: sixthsection)
        
        self.setShadow(view: updatebtn)
        self.setShadow(view: btnview)
        if let key = UserDefaults.standard.object(forKey: "profile_pic"){
            
            var profile =   UserDefaults.standard.value(forKey: "profile_pic")as! String
            
            
            var catPictureURL = NSURL(string: profile)
            
            self.updateprofileimg.sd_setImage(with: catPictureURL as! URL, placeholderImage: UIImage(named: "default-user"))
            //self.updateprofileimg.image = image
        }
    }
    
    @IBAction func btnaddvehicle(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Vehicle_informationViewController") as! Vehicle_informationViewController
        
        //        nextViewController.delegate = self as! cardnum
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkvehicle()
        
    }
    
    
    @IBAction func backbtnaction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
   var isfirst = "0"
    
    func  checkvehicle() {
        let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        
        
        Alamofire.request(WebServiceClass().BaseURL+"user/me", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    self.vehiclearray.removeAllObjects()
                    let dic = response.result.value as! NSDictionary
                    let data = dic.value(forKey: "data")as! NSDictionary
                    let newary = data.value(forKey: "vehicles")as! NSArray
                    // let mainarray = data.value(forKey: "vehiclemodel")as! NSArray
                    //   let vmakearray = data.value(forKey: "vmake")as! NSArray
                    self.vehiclearray = newary.mutableCopy() as! NSMutableArray
                    
                    if(self.vehiclearray.count == 1)
                    {
                        
                        if(self.isfirst == "0")
                        {
                        let dic: NSDictionary =  self.vehiclearray.object(at:0) as! NSDictionary

                        
                        let id = dic.value(forKey: "vehicle_id")as! NSNumber
                        
                        self.selectvehicle(str: id.stringValue)
                        }
                        else
                        {
                            self.maintableview.reloadData()
                            print(response.result.value!)
                        }
                    }
                    else{
                    //   self.vehiclemakearray = vmakearray.mutableCopy() as! NSMutableArray
                    self.maintableview.reloadData()
                    print(response.result.value!)
                    }
                }
                
            case .failure(_):
                print("error")
            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(vehiclearray.count == 0){
            tablevieheight.constant = 0
        }
        else if(vehiclearray.count == 1){
            tablevieheight.constant = 45
        }
        else if(vehiclearray.count == 2){
            tablevieheight.constant = 90
        }
            
        else{
            tablevieheight.constant = 90
        }
        return vehiclearray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : VehicleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! VehicleTableViewCell
        
        let dic: NSDictionary =  vehiclearray.object(at: indexPath.row)as! NSDictionary
        //        let dic1: NSDictionary =  vehiclemakearray.object(at: indexPath.row)as! NSDictionary
        // let decodedData =  dic.value(forKey: "year")as! String
        let year =  dic.value(forKey: "year")as! NSNumber
        let vehiclename =  dic.value(forKey: "vehicle_name")as! String
        let vehiclemodel =  dic.value(forKey: "vehicle_model")as! String
        let color =  dic.value(forKey: "color")as! String
        let selectedvehicle =  dic.value(forKey: "selected")as! NSNumber
        
        
        
        if(selectedvehicle == 1){
            cell.selectimg.image = UIImage(named: "rightgreen.png")
        }else{
            cell.selectimg.image = UIImage(named: "rightblack.png")
        }
        
        let alldata =
            year.stringValue+" "+vehiclename+" "+vehiclemodel+" "+color
        cell.lblname.text = alldata
        
        cell.vehicleview.layer.borderWidth = 1
        cell.vehicleview.layer.cornerRadius = 5
        cell.vehicleview.layer.borderColor = UIColor.gray.cgColor
        
        cell.btnvehicle.tag = indexPath.row
        
        cell.btnvehicle.addTarget(self, action: #selector(deleteallvehicle), for: .touchUpInside)
        return cell
        
    }
    
    
    
    @objc func deleteallvehicle(sender: UIButton){
        let dic: NSDictionary =  vehiclearray.object(at: sender.tag)as! NSDictionary
        let id = dic.value(forKey: "vehicle_id")as! NSNumber
        
        
        let refreshAlert = UIAlertController(title:nil, message: "Are you sure you want to delete this vehicle?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.deletevehicle(str: id.stringValue)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    func deletevehicle(str:String){
        
        print(str)
        if AppDelegate.hasConnectivity() == true
        {
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            
            let parameters = [
                "vehicle_id":str
                
                
                ] as [String : Any]
            Alamofire.request(WebServiceClass().BaseURL+"user/delete/vehicle", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(response.result.value!)
                        var dic = response.result.value as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber == 0)
                        {
                            let alert = UIAlertController(title: "Greego", message:dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.checkvehicle()
                            
                            
                        }
                        else{
                            let alert = UIAlertController(title: "Greego", message:dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                case .failure(_):
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic: NSDictionary =  vehiclearray.object(at: indexPath.row)as! NSDictionary
        
        let refreshAlert = UIAlertController(title:nil, message: "Are you sure you want this card as default card?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            let id = dic.value(forKey: "vehicle_id")as! NSNumber
            
            self.selectvehicle(str: id.stringValue)
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    func selectvehicle(str:String){
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            let parameters = [
                "vehicle_id":str
                
                ] as [String : Any]
            Alamofire.request(WebServiceClass().BaseURL+"user/select/vehicle", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    WebServiceClass().dismissprogress()
                    if let data = response.result.value{
                        print(response.result.value!)
                        var dic = response.result.value as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber == 0)
                        {
                            self.isfirst = "1"
                            
                            self.checkvehicle()
                            
                            self.maintableview.reloadData()
                          
                        }
                        else{
                            let alert = UIAlertController(title: "Greego", message:dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    @objc func imageTapped(gesture:UIGestureRecognizer) {
        if let profile1Pic = gesture.view as? UIImageView {
            print("Image Tapped")
            showActionSheet()
        }
    }
    func camera()
    {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func photoLibrary()
    {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    var imgstr = UIImage();
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        WebServiceClass().showprogress()
        imgstr = image
        updateprofileimg.image = image
        self.dismiss(animated: true, completion: nil)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        var url = NSURL(string: "https://www.kroslinkstech.in/greego/public/api/user/add/profile_pic")
        let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        let URL = try! URLRequest(url: "https://www.kroslinkstech.in/greego/public/api/user/add/profile_pic", method: .post, headers: headers)
        
        manager.upload(multipartFormData: { MultipartFormData in
            
            let maximumSize : CGFloat = 400*400
            var compressRatio = CGFloat()
            let imageSize1 : CGFloat = self.imgstr.size.width * self.imgstr.size.height
            
            
            if imageSize1 < maximumSize {
                compressRatio = 1
            }
                
            else {
                compressRatio = maximumSize / imageSize1
            }
            
            
            var  image1 = UIImageJPEGRepresentation(self.imgstr, 0.5)
            MultipartFormData.append(image1!, withName: "image", fileName: "swift_file.jpg", mimeType: "image/jpeg")
            
        },   usingThreshold: UInt64.init(), to:WebServiceClass().BaseURL + "user/add/profile_pic", method: .post, headers: headers)  { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.result.value!)
                    WebServiceClass().dismissprogress()

                    let dic = response.result.value as! NSDictionary
                    let data = dic.value(forKey: "data")as! NSDictionary
                    let img = data.value(forKey: "profile_pic")as! String
                    
                    UserDefaults.standard.set(img,forKey: "profile_pic")
                    var profile =   UserDefaults.standard.value(forKey: "profile_pic")as! String
                    
                    //  var baseurl = "http://innoviussoftware.com/greego/public/api/"+profile
                    var catPictureURL = NSURL(fileURLWithPath: profile)
                    //var catPictureData = NSData(contentsOf: catPictureURL as URL) // nil
                    // self.updateprofileimg.image = UIImage(data: catPictureData as! Data)
                    
                    self.updateprofileimg.sd_setImage(with: catPictureURL as URL, placeholderImage: UIImage(named: "default-user"))
                    self.updateprofileimg.image = image
                    if let err = response.error{
                        return
                    }
                }
            case .failure(let error):
                WebServiceClass().dismissprogress()

                print("Error in upload: \(error.localizedDescription)")
                
            }
        }
        
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - User Define Functions
    
    func setShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 2
    }
    
    @IBAction func btnupdateaction(_ sender: Any) {
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            
            var strfname : String?
            var strlname : String?
            
            
            
            if(txtfname.text != UserDefaults.standard.value(forKey: "fname") as! String)
            {
                
                strfname = txtfname.text!
                
            }
            else
            {
                
                strfname = UserDefaults.standard.value(forKey: "fname") as! String
                
            }
            
            if(txtlname.text != UserDefaults.standard.value(forKey: "lname") as! String)
            {
                
                strlname = txtlname.text!
                
            }
            else
            {
                
                strlname = UserDefaults.standard.value(forKey: "lname") as! String
            }
            
            
            var parameters: Parameters = [:]
            
            parameters = [
                "name":strfname!,
                "lastname":strlname!,
            ]
            
            
            Alamofire.request(WebServiceClass().BaseURL+"user/update", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    WebServiceClass().dismissprogress()
                    if let data = response.result.value{
                        print(response.result.value!)
                        let alert = UIAlertController(title: "Greego", message: "Suceessfully Updated.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        let user = UserDefaults.standard
                        
                        user.set(self.txtfname.text!, forKey: "fname")
                        user.set(self.txtlname.text!, forKey: "lname")
                        
                        user.synchronize()
                        
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

