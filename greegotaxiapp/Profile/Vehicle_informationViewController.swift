//
//  Vehicle_informationViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/5/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire

class Vehicle_informationViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
    var menufcID : String?
    var vehicleID : String?
    var vehtype: String?
    
    var manufactorary = NSArray()
    var modelary = NSArray()
    
    var pickerview  = UIPickerView()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBOutlet weak var lbl1: UILabel!
    
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var automaticbtn: UIButton!
    
    @IBOutlet weak var manualbtn: UIButton!
    
    
    @IBOutlet weak var makepicker: UITextField!
    @IBOutlet weak var modelpicker: UITextField!
    
    @IBOutlet weak var yearpicker: UITextField!
    
    @IBOutlet weak var colorpicker: UITextField!
    
    @IBOutlet weak var typepicker: UITextField!
    var pickeroption = ["one","two","three"]
    var vehicletype = ["sedan","suv","van"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        isautomatic = "0"

        checkvhicle()
        lbl1.clipsToBounds = true
        lbl2.clipsToBounds = true

        lbl1.layer.cornerRadius = lbl1.frame.width/2
        lbl2.layer.cornerRadius = lbl2.frame.width/2

        var toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePressed))
        
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.navigationController?.navigationBar.isHidden = true
        makepicker.inputAccessoryView = toolBar
        // yearpicker.inputAccessoryView = toolBar
        modelpicker.inputAccessoryView = toolBar
        typepicker.inputAccessoryView = toolBar
        // colorpicker.inputAccessoryView = toolBar
        
        pickerview.delegate = self
        pickerview.dataSource = self
        makepicker.inputView = pickerview
        //yearpicker.inputView = pickerview
        modelpicker.inputView = pickerview
        typepicker.inputView = pickerview
        // colorpicker.inputView = pickerview
    }
    
    
    @IBAction func backbtnaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func donePressed(){
        
        if(pickerview.tag == 0)
            
        {
            if(makepicker.text == "")
            {
                
                let dic: NSDictionary = manufactorary.object(at: 0) as! NSDictionary
                makepicker.text = dic.value(forKey: "name") as! String
                
                makepicker.resignFirstResponder()
                
                let num = dic.value(forKey: "id") as! NSNumber
                
                self.menufcID = num.stringValue
                
                self.checkmodel()
                
            }
            else
            {
                makepicker.resignFirstResponder()
                self.checkmodel()
                
            }
        }
        else  if(pickerview.tag == 1)
            
        {
            if(modelpicker.text == "")
            {
                
                let dic: NSDictionary = modelary.object(at: 0) as! NSDictionary
                modelpicker.text = dic.value(forKey: "model") as! String
                let num = dic.value(forKey: "id") as! NSNumber
                self.vehicleID = num.stringValue
                
                modelpicker.resignFirstResponder()
                
                
            }
            else
                
            {
                modelpicker.resignFirstResponder()
                
                
            }
            
        }
            
        else  if(pickerview.tag == 2)
            
        {
            if(typepicker.text == "")
            {
                
                
                typepicker.text = vehicletype[0] as! String
                
                typepicker.resignFirstResponder()
                
                self.vehtype = "0"
                
                
            }
            else
            {
                typepicker.resignFirstResponder()
                
            }
        }
        else
        {
            
        }
    }
    
    
    @IBAction func savebtnaction(_ sender: Any) {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let nameOfMonth = dateFormatter.date(from: yearpicker.text!)
        
        
        if(makepicker.text == "")
        {
            let alert = UIAlertController(title: "Greego", message: "Please required all feild", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(modelpicker.text == "")
        {
            let alert = UIAlertController(title: "Greego", message: "Please required all feild", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(yearpicker.text == "")
        {
            let alert = UIAlertController(title: "Greego", message: "Please required all feild", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(nameOfMonth! > date)
        {
            let alert = UIAlertController(title: "Greego", message: "Please Enter correct year", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(colorpicker.text == "")
        {
            let alert = UIAlertController(title: "Greego", message: "Please required all feild", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            
            if AppDelegate.hasConnectivity() == true
            {
                WebServiceClass().showprogress()

                let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
                let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
                
                let parameters = [
                    "vehicle_manufacturer_id":self.menufcID,
                    "vehicle_id":self.vehicleID,
                    "year":yearpicker.text!,
                    "color":colorpicker.text!,
                    "type":self.vehtype,
                    "transmission_type":self.isautomatic
                ]
                Alamofire.request(WebServiceClass().BaseURL+"user/add/vehicle", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                    
                    switch(response.result) {
                    case .success(_):
                        WebServiceClass().dismissprogress()

                        if let data = response.result.value{
                            print(response.result.value!)
                            var dic = response.result.value as! NSDictionary
                            
                            if(dic.value(forKey: "error_code") as! NSNumber == 0)
                            {
                              
                                self.selectvehicle(str: self.vehicleID!)
                                
                            }
                            else{
                                
                                let alert = UIAlertController(title: "Greego", message:dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
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
                            let alert = UIAlertController(title: "Greego", message:"Vehicle Added Successfully.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (Greego) in
                                
                                self.navigationController?.popViewController(animated: true)
                                
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
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
    
    
    func checkvhicle(){
        
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

            Alamofire.request(WebServiceClass().BaseURL+"get/manufacturers", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    WebServiceClass().dismissprogress()

                    if let data = response.result.value{
                        print(response.result.value!)
                        
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        
                        self.manufactorary = dic.value(forKey: "data") as! NSArray
                        
                        
                        self.pickerview.reloadAllComponents()
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
    
    
    func checkmodel(){
       
        
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()

            Alamofire.request(WebServiceClass().BaseURL+"get/vehicles", method: .post, parameters: ["vehicle_manufacturer_id":self.menufcID], encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    WebServiceClass().dismissprogress()

                    if let data = response.result.value{
                        print(response.result.value!)
                        
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        
                        self.modelary = dic.value(forKey: "data") as! NSArray
                        
                        
                        self.pickerview.reloadAllComponents()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tag = pickerview.tag
        print(textField.tag)
        if(textField == makepicker)
        {
            
            
            pickerview.tag = 0
            
        }
        
        
        
        if(textField == modelpicker){
            
            pickerview.tag = 1
            
            pickerview.reloadAllComponents()
            if(makepicker.text == ""){
                let alert = UIAlertController(title: "Greego", message: "Please choose make vehicle", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if(textField == typepicker){
            pickerview.tag = 2
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        if(pickerview.tag == 0)
        {
            return manufactorary.count
            
        }
        else if(pickerview.tag == 1)
        {
            return modelary.count
            
        }
        else if(pickerview.tag == 2)
        {
            return vehicletype.count
            
        }
            
        else
            
        {
            
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        
        if(pickerview.tag == 0)
        {
            let dic: NSDictionary = manufactorary[row] as! NSDictionary
            
            
            return dic.value(forKey: "name") as! String
            
        }
        else  if(pickerview.tag == 1)
        {
            let dic: NSDictionary = modelary[row] as! NSDictionary
            
            
            return dic.value(forKey: "model") as! String
            
        }
        else  if(pickerview.tag == 2)
        {
            
            
            return vehicletype[row] as! String
            
        }
        else
            
        {
            
            return ""
        }
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerview.tag == 0)
        {
            let dic: NSDictionary = manufactorary[row] as! NSDictionary
            
            
            makepicker.text = dic.value(forKey: "name") as! String
            
            let num = dic.value(forKey: "id") as! NSNumber
            
            self.menufcID = num.stringValue
        }
        else  if(pickerview.tag == 1)
        {
            let dic: NSDictionary = modelary[row] as! NSDictionary
            
            
            modelpicker.text = dic.value(forKey: "model") as! String
            
            let num = dic.value(forKey: "id") as! NSNumber
            
            self.vehicleID = num.stringValue
            
        }
        else
        {
            typepicker.text = vehicletype[row]
            
            
            let num = row as! NSNumber
            
            self.vehtype = num.stringValue
            
            
        }
        
        
    }
    
    var isautomatic : String?
    @IBAction func automaticbtnaction(_ sender: Any) {
        
        lbl1.isHidden = false
        lbl2.isHidden = true

        isautomatic = "0"
        
        automaticbtn.setTitleColor(UIColor(red:0.03, green:0.31, blue:0.38, alpha:1.0), for: .normal)
        
        manualbtn.setTitleColor(UIColor.darkGray, for: .normal)
        
        
    }
    
    @IBAction func manualbtnaction(_ sender: Any) {
      
        lbl2.isHidden = false
        lbl1.isHidden = true
        isautomatic = "1"
        
        manualbtn.setTitleColor(UIColor(red:0.03, green:0.31, blue:0.38, alpha:1.0), for: .normal)
        
        automaticbtn.setTitleColor(UIColor.darkGray, for: .normal)
        
    }
    override func viewDidLayoutSubviews()
    {
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

