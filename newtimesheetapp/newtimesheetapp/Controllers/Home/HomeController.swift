//
//  HomeController.swift
//  newtimesheetapp
//
//  Created by User on 28/06/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit
import SwiftyJSON


class HomeController: UIViewController {

    @IBOutlet weak var btnTimesheet: UIButton!
    @IBOutlet weak var btnPendingItems: UIButton!
    @IBOutlet weak var btnAnnouncements: UIButton!
    @IBOutlet weak var btnUpcomingEvents: UIButton!
    @IBOutlet weak var btnLeaveBalance: UIButton!
    @IBOutlet weak var btnVacationRequest: UIButton!
    
    var mutableData = NSMutableData()
    override func viewDidLoad() {
        super.viewDidLoad()
        getStatusColor() //---to get color status
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnClick(_ sender: UIButton) {
        switch sender {
        case btnTimesheet:
            print ("Success Timesheet")
            self.performSegue(withIdentifier: "timesheetHomeSegue", sender: self)
        case btnPendingItems:
            print("Success Pending items")
        case btnAnnouncements:
            print("Success Pending items")
        case btnUpcomingEvents:
            print("Success Pending items")
        case btnLeaveBalance:
            print("Success Pending items")
        case btnVacationRequest:
            print("Success Pending items")
        default:
            break
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
//--------to get colorstatus from api, code starts-------
extension HomeController: XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    func getStatusColor() {
        
       
        //let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=ValidateTSheetLogin")
//        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=SubordinateListTimeSheetStatus")
        let url = NSURL(string:"\(BASE_URL)/TimesheetService.asmx/SubordinateListTimeSheetStatus")
        let theRequest = NSMutableURLRequest(url: url! as URL)
        
        
        
        theRequest.httpMethod = "GET"
       
        
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
       /* if elementName == "ValidateTSheetLoginResult" {
            self.loginResult = true
        }*/
    }
    
    // Operations to do for each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(String(format : "foundCharacters / value %@", string))
       
            //            KRProgressHUD.dismiss()
            if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do{
                    let response = try JSON(data: dataFromString)
                    //                print("Jsondatatest->",response)
                    let json = try JSON(data: dataFromString)
                    print("Jsondatatest->",json)
                    for inneritem in json.arrayValue{
                        if inneritem["name"].stringValue == "Not Started"{
                        print("Color code Not Started==>",inneritem["color_code"].stringValue)
                            UserSingletonModel.sharedInstance.NotStartedColor = inneritem["color_code"].stringValue
                        }
                        if inneritem["name"].stringValue == "Saved"{
                            UserSingletonModel.sharedInstance.Saved = inneritem["color_code"].stringValue
                        }
                        if inneritem["name"].stringValue == "Submitted"{
                            UserSingletonModel.sharedInstance.Submitted = inneritem["color_code"].stringValue
                        }
                        if inneritem["name"].stringValue == "Returned"{
                            UserSingletonModel.sharedInstance.Returned = inneritem["color_code"].stringValue
                        }
                        if inneritem["name"].stringValue == "Approved"{
                            UserSingletonModel.sharedInstance.Approved = inneritem["color_code"].stringValue
                        }
                        if inneritem["name"].stringValue == "Posted"{
                            UserSingletonModel.sharedInstance.Posted = inneritem["color_code"].stringValue
                        }
                        if inneritem["name"].stringValue == "Partially Returned"{
                            UserSingletonModel.sharedInstance.PartiallyReturned = inneritem["color_code"].stringValue
                        }
                        if inneritem["name"].stringValue == "Partially Approved"{
                            UserSingletonModel.sharedInstance.PartiallyApproved = inneritem["color_code"].stringValue
                        }
                    }
                    
                }catch let error
                {
                    print(error)
                }
                    /*if let username = json[0]["user"]["name"].string {
                     //Now you got your value
                     } */
                 /*   if let status = json["status"].string{
                        
                    }*/
                    
                }
                
            }
        
    }

//--------to get colorstatus from api, code ends-------
