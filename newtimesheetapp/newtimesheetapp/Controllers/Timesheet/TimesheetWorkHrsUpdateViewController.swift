//
//  TimesheetWorkHrsUpdateViewController.swift
//  newtimesheetapp
//
//  Created by User on 13/07/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit
import SwiftyJSON

struct EmployeeTimesheetDetailsChildData{
    var Note:String!
    var AccountCode:String!
    var Hour:String!
    var TaskID:Int!
    var CostTypeID:Int!
    var ACSuffix:String!
    var ContractID:Int!
    var Contract:String!
    var Task:String!
    var CostType:String!
    var LaborCategoryID:Int!
    var LaborCategory:String!
}
struct EmployeeTimesheetParentData{
    var TimesheetDate:String!
    var WeekDate:String!
}
struct prepareToSave{
    var CorpID:[String:AnyObject]!
    var UserID:[String:AnyObject]!
    var WeekDate:[String:AnyObject]!
    var WeekStartDate:[String:AnyObject]!
    var TimeSheetDate:[String:AnyObject]!
}

class TimesheetWorkHrsUpdateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableviewWorkHrsUpdate: UITableView!
    var employeeTimeSheetListResult = false
    var mutableData = NSMutableData()
    var arrRes = [[String:AnyObject]]()
    var tableChildData = [EmployeeTimesheetDetailsChildData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeTimesheetAPICalling()
        // Do any additional setup after loading the view.
    }
    

    //========================tableview code starts===================
   
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hexFromString: "#2e5772")
        
        
        
        let labelAssignedTaskTitle = UILabel()
        labelAssignedTaskTitle.text = "Assigned Task(s)"
        labelAssignedTaskTitle.numberOfLines = 1;
        labelAssignedTaskTitle.font = UIFont.boldSystemFont(ofSize: 20)
        labelAssignedTaskTitle.textColor = UIColor(hexFromString: "#ffffff")
        labelAssignedTaskTitle.adjustsFontSizeToFitWidth = true;
        labelAssignedTaskTitle.frame = CGRect(x:8, y:5, width: labelAssignedTaskTitle.intrinsicContentSize.width, height: 20)
        view.addSubview(labelAssignedTaskTitle)
        
       
        
        let labelHoursTitle = UILabel()
        labelHoursTitle.text = "Hour(s)"
        labelHoursTitle.numberOfLines = 1;
        labelHoursTitle.font = UIFont.boldSystemFont(ofSize: 20)
        labelHoursTitle.textColor = UIColor(hexFromString: "#ffffff")
        labelHoursTitle.adjustsFontSizeToFitWidth = true;
        labelHoursTitle.frame = CGRect(x:self.view!.bounds.width - labelHoursTitle.intrinsicContentSize.width - 8, y:5, width: labelHoursTitle.intrinsicContentSize.width, height: 35)
        view.addSubview(labelHoursTitle)
        
       
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableChildData.count
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TimesheetWorkHrsUpdateTableViewCell
       /* let dict = arrRes[indexPath.row]
        cell.labelWrkHrsUpdateGlCode.text = dict["AccountCode"] as? String
        cell.labelWrkHrsUpdateTaskDescription.text = dict["Task"] as? String
        cell.labelWrkHrsUpdateLabourType.text = dict["LaborCategory"] as? String*/
        cell.viewChild.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.colorCode!)
        //         cell.tvWrkHrsAddHrs.text = dict["Hour"] as? String
        
        let dict1 = tableChildData[indexPath.row]
        cell.labelWrkHrsUpdateGlCode.text = dict1.AccountCode
        cell.labelWrkHrsUpdateTaskDescription.text = dict1.Task
        cell.labelWrkHrsUpdateLabourType.text = dict1.LaborCategory ?? ""
        
        cell.tvWrkHrsAddHrs.delegate = self
        cell.tvWrkHrsAddHrs.text = ""
//        cell.tvWrkHrsAddHrs.placeholder? = dict["Hour"] as? String ?? "0.0"
        cell.tvWrkHrsAddHrs.placeholder? = dict1.Hour ?? "0.0"
        cell.tvWrkHrsAddHrs?.autocorrectionType = UITextAutocorrectionType.no
        cell.tvWrkHrsAddHrs?.autocapitalizationType = UITextAutocapitalizationType.none
        cell.tvWrkHrsAddHrs?.adjustsFontSizeToFitWidth = true;
        return cell
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//         let indexOf = tableChildData.index(of:textField.placeholder)
        print("new text",textField.text as Any)
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableviewWorkHrsUpdate)
        let textFieldIndexPath = self.tableviewWorkHrsUpdate.indexPathForRow(at: pointInTable)
        tableChildData[(textFieldIndexPath?.row)!].Hour = textField.text
        tableviewWorkHrsUpdate.reloadData()
        
//        tableviewWorkHrsUpdate.reloadData()
        //        print(indexOf)
      /*   if(textField.placeholder! == tableChildData[indexOf!]){
         if( indexOf! <= (allCellsText.count – 1)){
         allCellsText.remove(at: indexOf!)
         }
         allCellsText.insert(textField.text!, at: indexOf!)
         print(allCellsText)
         }*/
    }
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //========================tableview code ends===================

}
// MARK: - XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
extension TimesheetWorkHrsUpdateViewController: XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    func employeeTimesheetAPICalling() {
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><EmployeeTimeSheetList xmlns='%@/'><CorpId>%@</CorpId><UserID>%@</UserID><WeekDate>%@</WeekDate><Selecteddate>%@</Selecteddate><EmpType>%@</EmpType><deviceType>1</deviceType></EmployeeTimeSheetList></soap12:Body></soap12:Envelope>",BASE_URL, String(describing: UserSingletonModel.sharedInstance.CorpID!),String(describing: UserSingletonModel.sharedInstance.UserID!),UserSingletonModel.sharedInstance.weekDate!,UserSingletonModel.sharedInstance.selectedDate!,UserSingletonModel.sharedInstance.UserType!)
        
        var soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=EmployeeTimeSheetList")
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
        if elementName == "EmployeeTimeSheetListResult" {
            self.employeeTimeSheetListResult = true
        }
    }
    
    // Operations to do for each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(String(format : "foundCharacters / value %@", string))
        if self.employeeTimeSheetListResult == true {
            
            
            /* if self.arrEmployeeTimeSheetDetails.count > 0 {
             self.arrEmployeeTimeSheetDetails.removeAll()
             }*/
            
            if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do{
                    let response = try JSON(data: dataFromString)
                    print("EmployeeTimesheet Data-=>",response)
                    if let resData = response["EmployeeTimeSheetDetails"].arrayObject{
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    //------newly adding----
                    for (key,value) in response["EmployeeTimeSheetDetails"]{
                        var data = EmployeeTimesheetDetailsChildData()
                        data.Note = value["Note"].stringValue
                        data.TaskID = value["TaskID"].intValue
                        data.ContractID = value["ContractID"].intValue
                        data.Contract = value["Contract"].stringValue
                        data.Task = value["Task"].stringValue
                        data.LaborCategory = value["LaborCategory"].stringValue
                        data.CostType = value["CostType"].stringValue
                        data.CostTypeID = value["CostTypeID"].intValue
                        data.LaborCategoryID = value["LaborCategoryID"].intValue
                        data.AccountCode = value["AccountCode"].stringValue
                        data.Hour = value["Hour"].stringValue
                        data.ACSuffix = value["ACSuffix"].stringValue
                        data.Note = value["Note"].stringValue
                        tableChildData.append(data)
                    }
                    //------newly adding ends-----
                }catch let error{
                    print("Error:",error)
                }
                
                if(arrRes.count>0){
                    tableviewWorkHrsUpdate.reloadData()
                }
            }
        }
    }
}
