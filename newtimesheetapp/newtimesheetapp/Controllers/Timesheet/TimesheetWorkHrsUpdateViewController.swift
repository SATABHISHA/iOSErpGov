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
    var CorpID:String!
    var UserID:Int!
    var WeekDate:String!
    var WeekStartDate:String!
    var TimeSheetDate:String!
    var Detail = [[String:AnyObject]]()
    // var Detail = [prepareToSaveDetails]()
}
struct prepareToSaveDetails{
    var ContractID:Int!
    var TaskID:Int!
    var LaborcatID:Int!
    var CostTypeID:Int!
    var Hour:String!
    var ZeroHourYN:String!
    var Note:String!
    var NoteType:String!
}

class TimesheetWorkHrsUpdateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var tableviewWorkHrsUpdate: UITableView!
    var employeeTimeSheetListResult = false
    var employeeTimeSheetSaveResult = false
    var strCheck = "EmployeeTimeSheetList"
    var mutableData = NSMutableData()
    var arrRes = [[String:AnyObject]]()
    var tableChildData = [EmployeeTimesheetDetailsChildData]()
    var collectUpdatedFullData = [Any]()
    var collectUpdatedDetailsData = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.strCheck = "EmployeeTimeSheetList"
        employeeTimesheetAPICalling()
        // Do any additional setup after loading the view.
       /* btnSave.isEnabled = false
        btnSave.alpha = CGFloat(0.1)*/
        if (UserSingletonModel.sharedInstance.timesheetStatusCode! == 4 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 2 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 5){
            btnSave.isEnabled = false
            btnSave.alpha = CGFloat(0.6)
        }else{
            btnSave.isEnabled = true
        }
    }
    @IBAction func onClickButtons(_ sender: UIButton) {
        switch sender {
        case ViewFormAlrtDialogSubmitMsgBtnOk:
            cancelSaveFormPopup()
            self.performSegue(withIdentifier: "timseheetSelectDay", sender: self)
        default:
            break
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.strCheck = "EmployeeTimeSheetSave"
        var data = prepareToSave()
        var Details = prepareToSaveDetails()
        data.CorpID = UserSingletonModel.sharedInstance.CorpID!
        data.UserID = UserSingletonModel.sharedInstance.UserID!
        data.WeekDate = UserSingletonModel.sharedInstance.weekDate!
        data.WeekStartDate = UserSingletonModel.sharedInstance.periodStartDate!
        data.TimeSheetDate = UserSingletonModel.sharedInstance.dayDate!
        var getData = [String:AnyObject]()
        for i in 0..<tableChildData.count{
            getData.updateValue(tableChildData[i].ContractID! as AnyObject, forKey: "ContractID")
            getData.updateValue(tableChildData[i].TaskID! as AnyObject, forKey: "TaskID")
            getData.updateValue(tableChildData[i].LaborCategoryID! as AnyObject, forKey: "LaborcatID")
            getData.updateValue(tableChildData[i].CostTypeID! as AnyObject, forKey: "CostTypeID")
            getData.updateValue(tableChildData[i].Hour! as AnyObject, forKey: "Hour")
            getData.updateValue("No" as AnyObject, forKey: "ZeroHourYN")
            getData.updateValue(tableChildData[i].Note! as AnyObject, forKey: "Note")
            getData.updateValue("emp" as AnyObject, forKey: "emp")
            collectUpdatedDetailsData.append(getData)
        }
        data.Detail = collectUpdatedDetailsData as! [[String:AnyObject]]
        collectUpdatedFullData.append(data)
        
        //-----------code to make jsonObject as string, starts-------
        let jsonObject: [String: Any] = [
            "CorpID": UserSingletonModel.sharedInstance.CorpID!,
            "UserID": UserSingletonModel.sharedInstance.UserID!,
            "WeekDate": UserSingletonModel.sharedInstance.weekDate!,
            "WeekStartDate": UserSingletonModel.sharedInstance.periodStartDate!,
            "TimeSheetDate": UserSingletonModel.sharedInstance.dayDate!,
            "Detail": collectUpdatedDetailsData,
            "EmpType": UserSingletonModel.sharedInstance.UserType!
        ]
        
        if let data=try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let str=String(data: data, encoding: .utf8){
            print("Latest value-->",str)
            employeeTimesheetSave(jsonObjectData: str)
            
        }
    }
    //-----------code to make jsonObject as string, ends-------
    
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
        labelHoursTitle.frame = CGRect(x:self.view!.bounds.width - labelHoursTitle.intrinsicContentSize.width - 8, y:5, width: labelHoursTitle.intrinsicContentSize.width, height: 20
        )
        view.addSubview(labelHoursTitle)
        
        
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        /*   parentTableview.estimatedRowHeight = CGFloat((60 * tableViewData[section].DayHrs.count)+70)
         parentTableview.rowHeight = CGFloat((60 * tableViewData[section].DayHrs.count)+70)*/
        //        return arrResChild.count
        //        return  tableViewData[section].DayHrs.count
        return tableChildData.count
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TimesheetWorkHrsUpdateTableViewCell
        cell.viewChild.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.colorCode!)
        //         cell.tvWrkHrsAddHrs.text = dict["Hour"] as? String
        
        let dict1 = tableChildData[indexPath.row]
        cell.labelWrkHrsUpdateGlCode.text = dict1.AccountCode
        cell.labelWrkHrsUpdateTaskDescription.text = dict1.Task
        cell.labelWrkHrsUpdateLabourType.text = dict1.LaborCategory ?? ""
        
        
        cell.tvWrkHrsAddHrs.delegate = self
        
        if dict1.Hour == "0.00"{
            cell.tvWrkHrsAddHrs.tag = indexPath.row
            cell.tvWrkHrsAddHrs.text = ""
        }else{
          cell.tvWrkHrsAddHrs.tag = indexPath.row
          cell.tvWrkHrsAddHrs.textColor = UIColor(hexFromString: "#626262")
          cell.tvWrkHrsAddHrs.text = dict1.Hour
        }
       /* cell.tvWrkHrsAddHrs.tag = indexPath.row
        cell.tvWrkHrsAddHrs.text = dict1.Hour*/
        //        cell.tvWrkHrsAddHrs.placeholder? = dict["Hour"] as? String ?? "0.0"
//        cell.tvWrkHrsAddHrs.placeholder? = dict1.Hour ?? "0.0"
        cell.tvWrkHrsAddHrs?.autocorrectionType = UITextAutocorrectionType.no
        cell.tvWrkHrsAddHrs?.autocapitalizationType = UITextAutocapitalizationType.none
        cell.tvWrkHrsAddHrs?.adjustsFontSizeToFitWidth = true;
        return cell
    }
   
  
   /* func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableviewWorkHrsUpdate)
        let textFieldIndexPath = self.tableviewWorkHrsUpdate.indexPathForRow(at: pointInTable)
        tableChildData[(textFieldIndexPath?.row)!].Hour = updatedString!
        print("new string-=>",updatedString!)
        tableviewWorkHrsUpdate.reloadData()
        return true
    }*/
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        tableChildData[textField.tag].Hour = updatedString!
        print("new string-=>",updatedString!)
        tableviewWorkHrsUpdate.reloadData()
        return true
    }
  /*  func textFieldDidEndEditing(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableviewWorkHrsUpdate)
        let textFieldIndexPath = self.tableviewWorkHrsUpdate.indexPathForRow(at: pointInTable)
//        tableChildData[(textFieldIndexPath?.row)!].Hour = textField.text!
        tableChildData[textField.tag].Hour = textField.text!
        print("new string-=>",textField.text!)
        tableviewWorkHrsUpdate.reloadData()
    }*/
  
   
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //========================tableview code ends===================
    
    //==========Save_response_dialog function to open, close, cancel and save save popup code starts=========
    
   
    
    /* @IBAction func btnFormDialogSubmit(_ sender: Any) {
     validatePasswordAndSubmit(stringCheck: "ValidatePassword",textField: tvPassword.text!)
     }*/
    
    //===============FormDialogValidate openPopup function code starts=============
    
    @IBOutlet var ViewFormAlertDialogSubmitMessage: UIView!
    @IBOutlet weak var ViewFormAlrtDialogSubmitMsgBtnOk: UIButton!
    @IBOutlet weak var ViewFormAlrtDialogSubmitLableMsg: UILabel!
    
    func openSaveFormPopup(message: String){
        blurEffect()
        self.view.addSubview(ViewFormAlertDialogSubmitMessage)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        ViewFormAlertDialogSubmitMessage.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        ViewFormAlertDialogSubmitMessage.center = self.view.center
        ViewFormAlertDialogSubmitMessage.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        ViewFormAlertDialogSubmitMessage.alpha = 0
        ViewFormAlertDialogSubmitMessage.sizeToFit()
        
        UIView.animate(withDuration: 0.3){
            self.ViewFormAlertDialogSubmitMessage.alpha = 1
            self.ViewFormAlertDialogSubmitMessage.transform = CGAffineTransform.identity
        }
        ViewFormAlrtDialogSubmitLableMsg.text = message
        
    }
    //===============FormDialogValidate openPopup function code ends===============
    //------FormDialogValidate close popup code starts------
    func cancelSaveFormPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewFormAlertDialogSubmitMessage.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.ViewFormAlertDialogSubmitMessage.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.ViewFormAlertDialogSubmitMessage.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    //-----FormDialogValidate close popup code ends-------
    
    
    //===========Save_response_dialog function to open, close, cancel and save save popup code ends==========
    // ====================== Blur Effect Defiend START ================= \\
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var blurEffectView: UIVisualEffectView!
    var loader: UIVisualEffectView!
    func loaderStart() {
        // ====================== Blur Effect START ================= \\
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        loader = UIVisualEffectView(effect: blurEffect)
        loader.frame = view.bounds
        loader.alpha = 2
        view.addSubview(loader)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.transform = transform
        loadingIndicator.center = self.view.center;
        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.white
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        loadingIndicator.startAnimating();
        loader.contentView.addSubview(loadingIndicator)
        
        // screen roted and size resize automatic
        loader.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
        
        // ====================== Blur Effect END ================= \\
    }
    
    func loaderEnd() {
        self.loader.removeFromSuperview();
    }
    // ====================== Blur Effect Defiend END ================= \\
    
    // ====================== Blur Effect function calling code starts ================= \\
    func blurEffect() {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.7
        view.addSubview(blurEffectView)
        // screen roted and size resize automatic
        blurEffectView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
        
    }
    func canelBlurEffect() {
        self.blurEffectView.removeFromSuperview();
    }
    // ====================== Blur Effect function calling code ends ================= 
}


// MARK: - XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
extension TimesheetWorkHrsUpdateViewController: XMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    func employeeTimesheetAPICalling() {
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><EmployeeTimeSheetList xmlns='%@/'><CorpId>%@</CorpId><UserID>%@</UserID><WeekDate>%@</WeekDate><Selecteddate>%@</Selecteddate><EmpType>%@</EmpType><deviceType>1</deviceType></EmployeeTimeSheetList></soap12:Body></soap12:Envelope>",BASE_URL, String(describing: UserSingletonModel.sharedInstance.CorpID!),String(describing: UserSingletonModel.sharedInstance.UserID!),UserSingletonModel.sharedInstance.weekDate!,UserSingletonModel.sharedInstance.dayDate!,UserSingletonModel.sharedInstance.UserType!)
        
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
    
    //---------function for save, code starts-----------
    func employeeTimesheetSave(jsonObjectData: String){
        loaderStart()
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><EmployeeTimeSheetSave xmlns='%@/'><data>%@</data></EmployeeTimeSheetSave></soap12:Body></soap12:Envelope>",BASE_URL, String(describing: jsonObjectData))
        
        var soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=EmployeeTimeSheetSave")
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
    //---------function for save, code ends-----------
    
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
        if elementName == "EmployeeTimeSheetSaveResult"{
            self.employeeTimeSheetSaveResult = true
        }
    }
    
    // Operations to do for each element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(String(format : "foundCharacters / value %@", string))
        if self.strCheck == "EmployeeTimeSheetList"{
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
                    
                    if(tableChildData.count>0){
                        tableviewWorkHrsUpdate.reloadData()
                    }
                }
            }
        }
        if self.strCheck == "EmployeeTimeSheetSave"{
            if self.employeeTimeSheetSaveResult == true {
                if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    loaderEnd()
                    do{
                        let response = try JSON(data: dataFromString)
                        print("EmployeeTimesheetSave Data-=>",response)
                        let status = response["status"].stringValue
                        if status == "1"{
                            openSaveFormPopup(message: response["message"].stringValue)
                        }else{
                            openSaveFormPopup(message: response["message"].stringValue)
                        }
                    }catch let error{
                        print("Error:",error)
                    }
                    
                    
                }
            }
        }
    }
}
