//
//  TimesheetSelectDayViewController.swift
//  newtimesheetapp
//
//  Created by User on 04/07/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimesheetSelectDayViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, TimesheetSelectDayChildTableViewCellDelegate {
   
    
    @IBOutlet weak var viewbtnEmployeeNote: UIView!
    @IBOutlet weak var viewbtnSupervisorNote: UIView!
    @IBOutlet weak var parentTableview: UITableView!
    var mutableData = NSMutableData()
    var getDayWiseTimeSheetResult = false
    var arrRes = [[String:AnyObject]]()
    var arrResChild = [[String:AnyObject]]()
    var dict:JSON!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataOfDayWiseTimesheet()
        self.parentTableview.delegate = self
        viewbtnEmployeeNote.roundCorners([.topLeft, .bottomLeft], radius: 20)
        viewbtnSupervisorNote.roundCorners([.topRight, .bottomRight], radius: 20)
        customViewButton()

    }
    //-----------------function for custom view onClick for button, starts------------
    func customViewButton(){
        let tapGestureRecognizerEmployee = UITapGestureRecognizer(target: self, action: #selector(viewbtnEmployeeNotetapped(tapGestureRecognizerEmployee:)))
        viewbtnEmployeeNote.isUserInteractionEnabled = true
        viewbtnEmployeeNote.addGestureRecognizer(tapGestureRecognizerEmployee)
        
        let tapGestureRecognizerSupervisor = UITapGestureRecognizer(target: self, action: #selector(viewbtnSupervisorNotetapped(tapGestureRecognizerSupervisor:)))
        viewbtnSupervisorNote.isUserInteractionEnabled = true
        viewbtnSupervisorNote.addGestureRecognizer(tapGestureRecognizerSupervisor)
        
    }
    @objc func viewbtnEmployeeNotetapped(tapGestureRecognizerEmployee: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("Employee tapped")
        
    }
    @objc func viewbtnSupervisorNotetapped(tapGestureRecognizerSupervisor: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
     print("Supervisor tapped")
        
    }
    //-----------------function for custom view onClick for button, ends------------
    override func viewWillAppear(_ animated: Bool) {
//        print("calculation-->",Int(CGFloat((119*self.arrResChild.count)+70)))
//        print("calculation row count-->",UserSingletonModel.sharedInstance.timesheetWeekDayCount!)
       /* parentTableview.estimatedRowHeight = Int((119 * arrResChild.count)+70)
        parentTableview.rowHeight = CGFloat(119*arrResChild.count+70)*/
    }
     //========================tableview code starts===================
    func TimesheetSelectDayChildTableViewCellDidTapAddOrView(_ sender: TimesheetSelectDayChildTableViewCell) {
        print("Tapped",UserSingletonModel.sharedInstance.timesheetStatusCode!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100
        {
        return arrRes.count
        }
        else{
            parentTableview.estimatedRowHeight = CGFloat((60 * arrResChild.count)+70)
            parentTableview.rowHeight = CGFloat((60 * arrResChild.count)+70)
        return arrResChild.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100{
        let cell = tableView.dequeueReusableCell(withIdentifier: "titlecell") as! TimesheetSelectDayTableViewCell
        
        /*var dict = arrRes[indexPath.row]
        cell.view_goal.layer.cornerRadius = 10.0
        cell.label_goal.text = dict["goal"] as? String
        cell.label_value_of_rating.text = "\(dict["valueOfTheRating"]!)"
        cell.label_date.text = "\(dict["created_at"]!)"*/
            var dict = arrRes[indexPath.row]
            cell.tvTitleWeekDate.text = dict["WeekDate"] as? String
            cell.tvTitleWeekDateHours.text = String(Double(dict["TotalHours"] as! Int))
            
            
        return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleChildCell") as! TimesheetSelectDayChildTableViewCell
            var dict = arrResChild[indexPath.row]
            cell.delegate = self
            cell.tvWeekDayName.text = dict["DayName"] as? String
            cell.tvWeekDayHours.text = String(Double(dict["Hours"] as! Int))
            cell.tvWeekDayDate.text = dict["DayDate"] as? String
            
            if (UserSingletonModel.sharedInstance.timesheetStatusCode! == 4 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 2 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 5 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 7 ){
                cell.imgViewAddOrView.image = UIImage(named: "viewbtn.png")
            }else{
                cell.imgViewAddOrView.image = UIImage(named: "addbtn.png")
            }
            return cell
        }
    }
  /*  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        /*let dataSource = arrResChild[indexPath.row]
        let innerCellsCount = arrResChild.count*/
        print("calculation row count-->",UserSingletonModel.sharedInstance.timesheetWeekDayCount!)
        return CGFloat(129*UserSingletonModel.sharedInstance.timesheetWeekDayCount)

    }*/
    //========================tableview code ends===================
    
}
//-------code for UIView shape(rounded corners), starts-------------
extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
//-------code for UIView shape(rounded corners), ends-------------
// MARK: - XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
extension TimesheetSelectDayViewController: XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    
    /// DayWiseAPICall
    func loadDataOfDayWiseTimesheet() {
        
//        self.activityIndicator.startAnimating()
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><GetDayWiseTimeSheet xmlns='%@/'><CorpId>%@</CorpId><UserId>%@</UserId><UserType>%@</UserType><StartDate>%@</StartDate><EmpType>%@</EmpType></GetDayWiseTimeSheet></soap12:Body></soap12:Envelope>",BASE_URL, String(describing: UserSingletonModel.sharedInstance.CorpID!),String(describing: UserSingletonModel.sharedInstance.UserID!),String(describing: UserSingletonModel.sharedInstance.UserType!),String(describing:UserSingletonModel.sharedInstance.selectedDate!),String(describing: UserSingletonModel.sharedInstance.UserType!))
        
        var soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=GetDayWiseTimeSheet")
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
    
    
    /// SubmitAPICall
    func employeeTimesheetSubmitAPICall() {
        
     /*   if String(describing: OBJ_FOR_KEY(key: "EmpType")!) == "Employee" {
            self.userID = String(describing: OBJ_FOR_KEY(key: "UserID")!)
        } else if String(describing: OBJ_FOR_KEY(key: "EmpType")!) == "Supervisor" {
            self.userID = self.empID
        } else {
            
        }
        
        KRProgressHUD.show(withMessage: "Loading...")
        //let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><EmployeeTimesheetSubmit xmlns='%@/'><UserId>%@</UserId><UserCode>%@</UserCode><CorpId>%@</CorpId><EmpType>EMPLOYEE</EmpType><DayDate>\(endDate)</DayDate><ReqNotes>%@</ReqNotes></EmployeeTimesheetSubmit></soap12:Body></soap12:Envelope>",BASE_URL, self.userID, String(describing: OBJ_FOR_KEY(key: "UserName")!), String(describing: OBJ_FOR_KEY(key: "CorpID")!),String(describing: OBJ_FOR_KEY(key: "EmpType")!),jsonModifiedString)
        //print(text)
        
        //"CorpID": OBJ_FOR_KEY(key: "CorpID")!, "UserType": "EMPLOYEE" as AnyObject, "UserID": OBJ_FOR_KEY(key: "UserID")!,"EmployeeNote": "","SupervisorNote": "","Weekdate":endDate, "WeekStartDate": startDate, "WeekEndDate": endDate]
        
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><EmployeeTimesheetSubmit xmlns='%@/'><CorpID>%@</CorpID><UserId>%@</UserId><Weekdate>\(endDate)</Weekdate><WeekStartDate>\(startDate)</WeekStartDate><WeekEndDate>\(endDate)</WeekEndDate><EmployeeNote>\(self.noteDict["EmployeeNote"] ?? "")</EmployeeNote><SupervisorNote>\(self.noteDict["SupervisorNote"] ?? "")</SupervisorNote><UserType>EMPLOYEE</UserType></EmployeeTimesheetSubmit></soap12:Body></soap12:Envelope>",BASE_URL, String(describing: OBJ_FOR_KEY(key: "CorpID")!), self.userID, String(describing: OBJ_FOR_KEY(key: "EmpType")!))
        print(text)
        var soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=EmployeeTimesheetSubmit")
        let theRequest = NSMutableURLRequest(url: url! as URL)
        let msgLength = String(soapMessage.characters.count)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        connection?.start()
        if (connection != nil) {
            let mutableData : Void = NSMutableData.initialize()
            print(mutableData)
        }*/
    }
    
    
    /// ApproveAPICall
    func employeeTimesheetApproveAPICall() {
//        KRProgressHUD.show(withMessage: "Loading...")
       /* let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><TimeSheetApprove xmlns='%@/'><ReqNotes>%@</ReqNotes><CorpId>%@</CorpId></TimeSheetApprove></soap12:Body></soap12:Envelope>",BASE_URL, jsonModifiedString,String(describing: OBJ_FOR_KEY(key: "CorpID")!))
        
        var soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=TimeSheetApprove")
        let theRequest = NSMutableURLRequest(url: url! as URL)
        let msgLength = String(soapMessage.characters.count)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        connection?.start()
        if (connection != nil) {
            let mutableData : Void = NSMutableData.initialize()
            print(mutableData)
        }*/
    }
    
    
    
    /// ApproveAPICall
    func employeeTimesheetReturnAPICall() {
//        KRProgressHUD.show(withMessage: "Loading...")
      /*  let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><TimeSheetReturn xmlns='%@/'><ReqNotes>%@</ReqNotes><CorpId>%@</CorpId></TimeSheetReturn></soap12:Body></soap12:Envelope>",BASE_URL, jsonModifiedString,String(describing: OBJ_FOR_KEY(key: "CorpID")!))
        
        var soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=TimeSheetReturn")
        let theRequest = NSMutableURLRequest(url: url! as URL)
        let msgLength = String(soapMessage.characters.count)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        connection?.start()
        if (connection != nil) {
            let mutableData : Void = NSMutableData.initialize()
            print(mutableData)
        } */
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
        if elementName == "GetDayWiseTimeSheetResult" {
            
            self.getDayWiseTimeSheetResult = true
        } /*else if elementName == "EmployeeTimesheetSubmitResult" {
            self.empTimesheetSUBMITResult = true
        } else if elementName == "TimeSheetApproveResult" {
            self.timeSheetApproveResult = true
        } else {
            self.timeSheetReturnResult = true
        }*/
    }
    
    // Operations to do for each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(String(format : "foundCharacters / value %@", string))
        
//            self.activityIndicator.stopAnimating()
            if self.getDayWiseTimeSheetResult == true {
                
             /*   if self.arrDayWiseTimesheet.count > 0 {
                    self.arrDayWiseTimesheet.removeAll()
                }*/
                if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do{
                    let response = try JSON(data: dataFromString)
                    let status = response["status"].stringValue
                        if (status == "true"){
                            print("result--->","success")
                            UserSingletonModel.sharedInstance.timesheetStatusCode = response["DayWiseTimeSheet"][0]["statusCode"].intValue
                            if let resData = response["DayWiseTimeSheet"][0]["WeekDays"].arrayObject{
                                arrRes = resData as! [[String:AnyObject]]
                            }
                            print("jsontestEmployee--->",arrRes)
                            for index in 0...self.arrRes.count{
                                if let resData = response["DayWiseTimeSheet"][0]["WeekDays"][index]["DayHrs"].arrayObject{
                                    arrResChild = resData as! [[String:AnyObject]]
                                }
//                                print("jsontestEmployee--->",arrResChild)
                            }
                       
                            if self.arrRes.count>0{
                                self.parentTableview.reloadData()
                            }
                        }
//                    print("JsondatatestEmployee->",response)
                    } catch let error
                    {
                        print(error)
                    }
                   
                    }
                }
            }
    
    }
    
   
   
    

