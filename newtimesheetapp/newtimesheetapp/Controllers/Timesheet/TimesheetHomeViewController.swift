//
//  TimesheetHomeViewController.swift
//  newtimesheetapp
//
//  Created by User on 29/06/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar

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
    
    
    var arrNotStartedDates = [String]()
    var arrSavedDates = [String]()
    var arrApprovedDates = [String]()
    var arrPartiallyApprovedDates = [String]()
    var arrSubmitted = [String]()
    var arrPosted = [String]()
    var arrReturned = [String]()
    var arrPartiallyReturned = [String]()
    let todayDate = Date()
    
//    ==================added on 2nd june code starts=========================
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter
    }()
    //==============variables for calender starts==========
    
   
    @IBOutlet weak var calender: FSCalendar!
    
    var arrColorCode = [String]()
    var arrDescription = [String]()
    var arrPeriod = [String]()
    var arrStatus = [String]()
    var arrTotalHours = [String]()
    var arrRes = [[String:AnyObject]]()
    var arrRes1 = [String:AnyObject]()
    var dict:[String:Any] = [:]
//    var dictjson : [String:AnyObject] = [:]
//    var dictDayStatus : [String:AnyObject] = [:]
    var dictjson = [String:AnyObject]()
    var dictDayStatus = [String:AnyObject]()
    //==============crerating structure, starts=============
    struct DayStatus{
        var ColorCode:String
        var Description:String
        var Period:String
        var Status:String
        var TotalHours:String
    }
    var DayStatusDict = [String:DayStatus]()
    var DayStatusDict1 = [String:String]()
    //==============crerating structure, ends=============
    
    func UIColorRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor? {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //==============variables for calender ends==========
    //    ==================added on 2nd june code ends=========================
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
        
        calender.headerHeight = 45.0
        calender.weekdayHeight = 35.0
        calender.rowHeight = 35.0
        calender.appearance.titleFont = UIFont.boldSystemFont(ofSize: 13.0)
        calender.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16.0)
        calender.scrollDirection = .horizontal
        calender.appearance.todayColor = .purple
        calender.calendarHeaderView.backgroundColor = UIColorRGB(r: 75, g: 153.0, b: 224.0)
        calender.appearance.headerTitleColor = .white
        calender.appearance.weekdayTextColor = .black
        calender.appearance.titleTodayColor = .black
        calender.appearance.borderRadius = 0
        calender.appearance.headerMinimumDissolvedAlpha = 0
        calender.backgroundColor = UIColor.white
    }
    
    


}
// MARK: - XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
extension TimesheetHomeViewController: XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    func weekDatesAPICall() {
        
        //        KRProgressHUD.show(withMessage: "Loading...")
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><GenerateWeekDates xmlns='%@/'><CorpId>%@</CorpId><UserId>%@</UserId><UserType>%@</UserType><StartDate>%@</StartDate><EndDate>%@</EndDate><CompanyId>%@</CompanyId></GenerateWeekDates></soap12:Body></soap12:Envelope>",BASE_URL, String(describing:UserSingletonModel.sharedInstance.CorpID!), String(describing:UserSingletonModel.sharedInstance.UserID!),String(describing:UserSingletonModel.sharedInstance.UserType!),"06-01-2018","08-31-2019",String(describing:UserSingletonModel.sharedInstance.CompID!))
        
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
//            print(mutableData)
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
//        print(String(format : "didStartElement / elementName %@", elementName))
        if elementName == "GenerateWeekDatesResult" {
            self.generateWeekDatesResult = true
        }
    }
    
    // Operations to do for each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        print(String(format : "foundCharacters / value %@", string))
        if self.generateWeekDatesResult == true {
            
            self.removeAllArrayValue()
            
            //            KRProgressHUD.dismiss()
            if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do{
                    let response = try JSON(data: dataFromString)
                    //                    print("ResponseData Test->",response)
                    let json = try JSON(data: dataFromString)
//                    print("Jsondatatest->",json)
                    if json.dictionary != nil{
                        for (key,value) in json.dictionary!{
                            dictjson[key] = JSON(value) as AnyObject
                        }
//                        print("Dictionary test==>",dictjson)
                    }
                    /*if let username = json[0]["user"]["name"].string {
                     //Now you got your value
                     } */
                    if let status = json["status"].string{
                        if status == "true"{
                            //                           arrColorCode.append(json["DayStatus"])
                            for innerItem in json["DayStatus"].arrayValue {
                                /*  let noteImage = NoteImage(imageUrl: innerItem["imageUrl"].stringValue)
                                 self.noteImages.append(noteImage)*/
                                arrColorCode.append(innerItem["ColorCode"].stringValue)
                                arrDescription.append(innerItem["Description"].stringValue)
                                arrStatus.append(innerItem["Status"].stringValue)
                                arrTotalHours.append(innerItem["TotalHours"].stringValue)
                                arrPeriod.append(innerItem["Period"].stringValue)
                            }
                            
                            if let resData = json["DayStatus"].arrayObject{
                                self.arrRes = resData as! [[String:AnyObject]]
                                /*dict = convertToDictionary(text: resData as! [])
                                 print("Dictionary test:==>",dict)*/
                            }
//                            let d1 = dictDayStatus["DayStatus"]! as Any
//                            print("dictonary test==>",dictjson["DayStatus"] as AnyObject)
                        
                           
                            
                            if self.arrRes.count>0 {
                                /*self.calendar.delegate = self
                                 self.calendar.dataSource = self
                                 self.calendar.reloadData()*/
                                self.calender.delegate = self
                                self.calender.dataSource = self
                                self.calender.reloadData()
                            }
                            print("array test: \(self.arrRes)")
                            
                        }
                    }
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
// MARK: - FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance
extension TimesheetHomeViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.formatter.string(from: date)
        /*  if self.arrNotStartedDates.contains(dateString) || self.arrSavedDates.contains(dateString) || self.arrApprovedDates.contains(dateString) || self.arrSubmitted.contains(dateString) || self.arrReturned.contains(dateString) || self.arrPosted.contains(dateString) {
         calendar.appearance.selectionColor = UIColor.init(named: "2E5772")
         calendar.appearance.titleSelectionColor = .white
         for dateStatus in self.arrDayStatus {
         let val = dateStatus as! DayStatus
         if dateString == val.period! {
         self.presentDayWiseAlertWithTitle(title: "\(dateString)", message: "Status: \(val.strDescription!)\n Hours: \(val.totalHours!)", hexCode: val.colorCode!, status: val.strDescription!, empType: String(describing: OBJ_FOR_KEY(key: "EmpType")!))
         
         }
         }
         } else {
         calendar.appearance.selectionColor = .clear
         calendar.appearance.titleSelectionColor = .black
         }*/
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    /// Maximum Date
    ///
    /// - Parameter calendar: Calendar Properties
    /// - Returns: Date
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "08-31-2019")!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "05-01-2019")!
    }
    
    
    
    /// Fill Color of Selected Dates
    ///
    /// - Parameters:
    ///   - calendar: Calendar Properties
    ///   - appearance: Fill Color of Each Date
    ///   - date: Date
    /// - Returns: Color
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString = self.formatter.string(from: date)
        /*calendar.appearance.selectionColor = UIColor.init(named: "#D2691E")
         return UIColor.init(named: "#D2691E")*/
        /*calendar.appearance.selectionColor = UIColorRGB(r: 255.0, g: 242.0, b: 207.0)
         return UIColorRGB(r: 255.0, g: 242.0, b: 207.0)*/
        /* calendar.appearance.selectionColor = UIColor(hexFromString: "#000000")
         return UIColor(hexFromString: "#000000")*/
        /* for calenderdata in arrRes{
         for (key,value) in calenderdata{
         
         
         calendar.appearance.selectionColor = UIColor.init(named: "#FBFBFB")
         return UIColor.init(named: "#FBFBFB")
         print("key test->","ColorCode")
         }
         }*/
        
//         print("dictonary test in calender==>",dictjson)
       /* for (key,value) in dictjson["DayStatus"]. {
            dictDayStatus
        }*/
        if self.arrPeriod.contains(dateString){
            /* calendar.appearance.selectionColor = UIColor(hexFromString: arrColorCode)
             return UIColor(hexFromString: color)*/
        }else{
            return .clear
        }
        return .clear
        
        /*   if String(describing: OBJ_FOR_KEY(key: "EmpType")!) == "Employee" {
         calendar.appearance.titleSelectionColor = .black
         if self.arrNotStartedDates.contains(dateString) {
         calendar.appearance.selectionColor = .white
         return .white
         } else if self.arrSavedDates.contains(dateString) {
         calendar.appearance.selectionColor = UIColorRGB(r: 255.0, g: 242.0, b: 207.0)
         return UIColorRGB(r: 255.0, g: 242.0, b: 207.0)
         } else if self.arrApprovedDates.contains(dateString) {
         calendar.appearance.selectionColor = UIColorRGB(r: 182.0, g: 238.0, b: 253.0)
         return UIColorRGB(r: 182.0, g: 238.0, b: 253.0)
         } else if self.arrReturned.contains(dateString) {
         calendar.appearance.selectionColor = UIColorRGB(r: 255.0, g: 198.0, b: 176.0)
         return UIColorRGB(r: 255.0, g: 198.0, b: 176.0)
         } else if self.arrSubmitted.contains(dateString) {
         calendar.appearance.selectionColor = UIColorRGB(r: 245.0, g: 212.0, b: 254.0)
         return UIColorRGB(r: 245.0, g: 212.0, b: 254.0)
         } else if self.arrPosted.contains(dateString) {
         calendar.appearance.selectionColor = UIColorRGB(r: 226.0, g: 240.0, b: 217.0)
         return UIColorRGB(r: 226.0, g: 240.0, b: 217.0)
         } else {
         calendar.appearance.selectionColor = .clear
         return .clear
         }
         } else if String(describing: OBJ_FOR_KEY(key: "EmpType")!) == "Supervisor" {
         if self.arrNotStartedDates.contains(dateString) || self.arrSavedDates.contains(dateString) || self.arrApprovedDates.contains(dateString) || self.arrReturned.contains(dateString) || self.arrSubmitted.contains(dateString) || self.arrPosted.contains(dateString) {
         return UIColor.init(hexString: "C0C0C0")
         } else {
         return .clear
         }
         } else {
         return .clear
         }*/
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let dateString = self.formatter.string(from: date)
        
        /* if String(describing: OBJ_FOR_KEY(key: "EmpType")!) == "Employee" {
         
         if self.arrNotStartedDates.contains(dateString) {
         return .darkGray
         } else if self.arrSavedDates.contains(dateString) {
         return .brown
         } else if self.arrApprovedDates.contains(dateString) {
         return UIColorRGB(r: 64.0, g: 175.0, b: 232.0)
         } else if self.arrReturned.contains(dateString) {
         return UIColorRGB(r: 255.0, g: 89.0, b: 65.0)
         } else if self.arrSubmitted.contains(dateString) {
         return UIColorRGB(r: 236.0, g: 165.0, b: 26.0)
         } else if self.arrPosted.contains(dateString) {
         return UIColorRGB(r: 115.0, g: 158.0, b: 0.0)
         } else {
         return .clear
         }
         
         
         } else if String(describing: OBJ_FOR_KEY(key: "EmpType")!) == "Supervisor" {
         
         if self.arrNotStartedDates.contains(dateString) || self.arrSavedDates.contains(dateString) || self.arrApprovedDates.contains(dateString) || self.arrReturned.contains(dateString) || self.arrSubmitted.contains(dateString) || self.arrPosted.contains(dateString) {
         return .black
         } else {
         return .clear
         }
         
         } else {
         return .clear
         }*/
        return .clear
    }
    
}

//-----------hexacode color conversion---------
extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
