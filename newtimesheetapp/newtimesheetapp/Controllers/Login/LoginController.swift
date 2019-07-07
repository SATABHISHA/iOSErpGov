//
//  LoginController.swift
//  newtimesheetapp
//
//  Created by User on 28/06/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class LoginController: UIViewController {
    
    let BASE_URL = "http://220.225.40.151:9012"
    @IBOutlet weak var corpId: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    var loginResult = false
    var mutableData = NSMutableData()
    var arrRes = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        self.Validate()
    }
    
    func Validate(){
        if (corpId.text == "" || userName.text == "" || password.text == ""){
            var style = ToastStyle()
            
            // this is just one of many style options
            style.messageColor = .white
            
            // present the toast with the new style
            self.view.makeToast("Field cannot be left empty", duration: 3.0, position: .bottom, style: style)
        }else {
            self.loginAPICall()
          /*  if Connectivity.isConnectedToInternet {
                self.loginAPICall()
            }
            else{
                print("No Internet is available")
                var style = ToastStyle()
                
                // this is just one of many style options
                style.messageColor = .white
                
                // present the toast with the new style
                self.view.makeToast("No Internet Connection", duration: 3.0, position: .bottom, style: style)
                }*/
             }
    }

}
// MARK: - XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
extension LoginController: XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    func loginAPICall() {
        
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><ValidateTSheetLogin xmlns='%@/'><CorpID>%@</CorpID><UserName>%@</UserName><Password>%@</Password></ValidateTSheetLogin></soap12:Body></soap12:Envelope>",BASE_URL, corpId.text!, userName.text!, password.text!)
        
        var soapMessage = text
        //let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=ValidateTSheetLogin")
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=ValidateTSheetLogin")
        let theRequest = NSMutableURLRequest(url: url! as URL)
        let msgLength = String(soapMessage.count)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        connection?.start()
        if (connection != nil) {
            let mutableData : Void = NSMutableData.initialize()
            print(mutableData)
        }
    }
    
    // MARK: - Web Service
    
    internal func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        mutableData.length = 0;
    }
    
    internal func connection(_ connection: NSURLConnection, didReceive data: Data) {
        mutableData.append(data as Data)
    }
    
    // Parse the result right after loading
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        print(mutableData)
        _ = NSString(data: mutableData as Data, encoding: String.Encoding.utf8.rawValue)
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
    // NSXMLParserDelegate
    
    // Operation to do when a new element is parsed
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print(String(format : "didStartElement / elementName %@", elementName))
        if elementName == "ValidateTSheetLoginResult" {
            self.loginResult = true
        }
    }
    
    // Operations to do for each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(String(format : "foundCharacters / value %@", string))
        if self.loginResult == true {
//            KRProgressHUD.dismiss()
            if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do{
                 let response = try JSON(data: dataFromString)
//                print("Jsondatatest->",response)
                    let json = try JSON(data: dataFromString)
                    print("Jsondatatest->",json)
                    /*if let username = json[0]["user"]["name"].string {
                        //Now you got your value
                    } */
                    if let status = json["status"].string{
                        if status == "true"{
                            print("status tet",status)
                            UserSingletonModel.sharedInstance.CompanyName = json["UserLogin"][0]["CompanyName"].string
                            UserSingletonModel.sharedInstance.PayableClerkYN = json["UserLogin"][0]["PayableClerkYN"].int
                            UserSingletonModel.sharedInstance.UserID = json["UserLogin"][0]["UserID"].int
                            UserSingletonModel.sharedInstance.AdminYN = json["UserLogin"][0]["AdminYN"].int
                            UserSingletonModel.sharedInstance.SupervisorId = json["UserLogin"][0]["SupervisorId"].int
                            UserSingletonModel.sharedInstance.SupervisorYN = json["UserLogin"][0]["SupervisorYN"].int
                            UserSingletonModel.sharedInstance.UserName = json["UserLogin"][0]["UserName"].string
                            UserSingletonModel.sharedInstance.PwdSetterId = json["UserLogin"][0]["PwdSetterId"].int
                            UserSingletonModel.sharedInstance.CompID = json["UserLogin"][0]["CompID"].int
                            UserSingletonModel.sharedInstance.CorpID = json["UserLogin"][0]["CorpID"].string
                            UserSingletonModel.sharedInstance.Msg = json["UserLogin"][0]["Msg"].string
                            UserSingletonModel.sharedInstance.EmailId = json["UserLogin"][0]["EmailId"].string
                            UserSingletonModel.sharedInstance.UserRole = json["UserLogin"][0]["UserRole"].string
                            UserSingletonModel.sharedInstance.UserType = json["UserLogin"][0]["UserType"].string
                            UserSingletonModel.sharedInstance.FinYearID = json["UserLogin"][0]["FinYearID"].string
                            UserSingletonModel.sharedInstance.PurchaseYN = json["UserLogin"][0]["PurchaseYN"].int
                            UserSingletonModel.sharedInstance.PayrollClerkYN = json["UserLogin"][0]["PayrollClerkYN"].int
                            UserSingletonModel.sharedInstance.EmpName = json["UserLogin"][0]["EmpName"].string
                            self.performSegue(withIdentifier: "homeSegue", sender: self)
                            
                        }
                    }
                    print("Company name test->",json["UserLogin"][0]["CompanyName"].string ?? "not available")
                }catch let error
                {
                    print(error)
                }
              
            }
        }
    }
}
