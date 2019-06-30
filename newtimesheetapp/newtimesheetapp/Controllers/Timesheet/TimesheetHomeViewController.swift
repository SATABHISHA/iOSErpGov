//
//  TimesheetHomeViewController.swift
//  newtimesheetapp
//
//  Created by User on 29/06/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimesheetHomeViewController: UIViewController {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgSaved: UIImageView!
    @IBOutlet weak var imgApproved: UIImageView!
    @IBOutlet weak var imgPartiallyApproved: UIImageView!
    @IBOutlet weak var imgSubmitted: UIImageView!
    @IBOutlet weak var imgNotStarted: UIImageView!
    @IBOutlet weak var imgPosted: UIImageView!
    var arrDayStatus = [AnyObject]()
    var generateWeekDatesResult = false
    var mutableData = NSMutableData()
    
//    @IBOutlet weak var calender: FSCalendar!
    var arrNotStartedDates = [String]()
    var arrSavedDates = [String]()
    var arrApprovedDates = [String]()
    var arrPartiallyApprovedDates = [String]()
    var arrSubmitted = [String]()
    var arrPosted = [String]()
    var arrReturned = [String]()
    var arrPartiallyReturned = [String]()
    let todayDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imgPartiallyApproved.layer.borderWidth = 1.0
        self.imgPartiallyApproved.layer.borderColor = UIColorRGB(r: 255.0, g: 89.0, b:65.0)?.cgColor
        self.imgPosted.layer.borderWidth = 1.0
        self.imgPosted.layer.borderColor = UIColorRGB(r: 115.0, g: 158.0, b: 0.0)?.cgColor
        self.imgSaved.layer.borderWidth = 1.0
        self.imgSaved.layer.borderColor = UIColor.brown.cgColor
        self.imgApproved.layer.borderWidth = 1.0
        self.imgApproved.layer.borderColor = UIColorRGB(r: 64.0, g: 175.0, b: 232.0)?.cgColor
        self.imgSubmitted.layer.borderWidth = 1.0
        self.imgSubmitted.layer.borderColor = UIColorRGB(r: 237.0, g: 181.0, b: 252.0)?.cgColor
        self.imgNotStarted.layer.borderWidth = 1.0
        self.imgNotStarted.layer.borderColor = UIColor.darkGray.cgColor
        
        self.weekDatesAPICall()
    }
    
    
    func UIColorRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor? {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }

}
// MARK: - XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
extension TimesheetHomeViewController: XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    func weekDatesAPICall() {
        
//        KRProgressHUD.show(withMessage: "Loading...")
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><GenerateWeekDates xmlns='%@/'><CorpId>%@</CorpId><UserId>%@</UserId><UserType>%@</UserType><StartDate>05-01-2019</StartDate><EndDate>07-31-2020</EndDate><CompanyId>1</CompanyId></GenerateWeekDates></soap12:Body></soap12:Envelope>",BASE_URL, String(describing:String(UserSingletonModel.sharedInstance.CorpID)),String(describing:String(UserSingletonModel.sharedInstance.UserID)),String(describing:String(UserSingletonModel.sharedInstance.UserType)))
        
        var soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=GenerateWeekDates")
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
        if elementName == "GenerateWeekDatesResult" {
            self.generateWeekDatesResult = true
        }
   }
    
    // Operations to do for each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(String(format : "foundCharacters / value %@", string))
        if self.generateWeekDatesResult == true {
            
            self.removeAllArrayValue()
            
//            KRProgressHUD.dismiss()
            if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do{
                let response = try JSON(data: dataFromString)
                    print("ResponseData Test->",response)
                }
                catch let error
                {
                    print(error)
                }
             /*   if response.dictionary!["status"]?.stringValue == SUCCESS {
                    if response["DayStatus"].count > 0 {
                        for value in response["DayStatus"].arrayObject! {
                            let objDayStatus = DayStatus(withDictionary: value as! [String : AnyObject])
                            if objDayStatus.strDescription! == "Saved" {
                                self.arrSavedDates.append(objDayStatus.period!)
                            } else if objDayStatus.strDescription! == "Not Started" {
                                self.arrNotStartedDates.append(objDayStatus.period!)
                            } else if objDayStatus.strDescription! == "Approved" {
                                self.arrApprovedDates.append(objDayStatus.period!)
                            } else if objDayStatus.strDescription! == "Partially Approved" {
                                self.arrPartiallyApprovedDates.append(objDayStatus.period!)
                            } else if objDayStatus.strDescription! == "Submitted" {
                                self.arrSubmitted.append(objDayStatus.period!)
                            } else if objDayStatus.strDescription! == "Posted" {
                                self.arrPosted.append(objDayStatus.period!)
                            } else if objDayStatus.strDescription! == "Returned" {
                                self.arrReturned.append(objDayStatus.period!)
                            } else {
                                self.arrPartiallyReturned.append(objDayStatus.period!)
                            }
                            self.arrDayStatus.append(objDayStatus)
                        }
                        self.calendar.delegate = self
                        self.calendar.dataSource = self
                        self.calendar.reloadData()
                    } */
                }
            }
        }
    }
// MARK: - Remove All Array Values
extension TimesheetHomeViewController {
    func removeAllArrayValue() {
        if self.arrPosted.count > 0 {
            self.arrPosted.removeAll()
        }
        
        if self.arrReturned.count > 0 {
            self.arrReturned.removeAll()
        }
        
        if self.arrSubmitted.count > 0 {
            self.arrSubmitted.removeAll()
        }
        
        if self.arrDayStatus.count > 0 {
            self.arrDayStatus.removeAll()
        }
        
        if self.arrSavedDates.count > 0 {
            self.arrSavedDates.removeAll()
        }
        
        if self.arrApprovedDates.count > 0 {
            self.arrApprovedDates.removeAll()
        }
        
        if self.arrNotStartedDates.count > 0 {
            self.arrNotStartedDates.removeAll()
        }
        
        if self.arrPartiallyReturned.count > 0 {
            self.arrPartiallyReturned.removeAll()
        }
    }
}
