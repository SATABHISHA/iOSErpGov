//
//  TimesheetSelectDayViewController.swift
//  newtimesheetapp
//
//  Created by User on 04/07/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit
import SwiftyJSON

struct cellData{
    var WeekDate:String!
    var ColorCode:String!
    var TotalHours:Int!
    var StatusDescription:String!
    var DayStatus:Int!
    var DayHrs = [[String:AnyObject]]()
}
class TimesheetSelectDayViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, TimesheetSelectDayTableViewCellDelegate
    
{
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var tvPeriodDate: UITextView!
    @IBOutlet weak var tvTotalhrs: UITextView!
    
    @IBOutlet weak var viewbtnEmployeeNote: UIView!
    @IBOutlet weak var viewbtnSupervisorNote: UIView!
    @IBOutlet weak var parentTableview: UITableView!
    
   
    @IBOutlet weak var tvStatus: UITextView!
    @IBOutlet weak var viewStatusColor: UIView!
    
    @IBOutlet weak var btnMenuHome: UIBarButtonItem!
    
    @IBOutlet weak var btnMenuBack: UIBarButtonItem!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var mutableData = NSMutableData()
    var getDayWiseTimeSheetResult = false
    var ValidatePasswordResult = false
    var SubmitTimesheetData = false
    var arrRes = [[String:AnyObject]]()
    var arrResChild = [[String:AnyObject]]()
    var childSection:JSON!
    var getAllData = [String:AnyObject]()
    var getAllData1 = [String:AnyObject]()
    var tableViewData = [cellData]()
    
//    var arrResChild:[[String:AnyObject]]!
    var dict:JSON!
    var strCheck = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.parentTableview.delegate = self
        self.parentTableview.dataSource = self
        labelUserName.text = UserSingletonModel.sharedInstance.EmpName!
        
        //------making textview editing mode false----
        tvStatus.isEditable = false
        
        tvPeriodDate.isEditable = false
        tvTotalhrs.isEditable = false
        //------making textview editing mode false, code ends----
        viewbtnSupervisorNote.roundCorners([.topRight, .bottomRight], radius: 20)
        viewbtnEmployeeNote.roundCorners([.topLeft, .bottomLeft], radius: 20)
       
        
       
        
        customViewButton()
        self.loadDataOfDayWiseTimesheet(stringCheck: "GetDaywiseTimesheet")
        parentTableview.reloadData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
//        print("calculation-->",Int(CGFloat((119*self.arrResChild.count)+70)))
//        print("calculation row count-->",UserSingletonModel.sharedInstance.timesheetWeekDayCount!)
       /* parentTableview.estimatedRowHeight = Int((119 * arrResChild.count)+70)
        parentTableview.rowHeight = CGFloat(119*arrResChild.count+70)*/
       /* let tv : TimesheetSelectDayViewController = self.children[0] as! TimesheetSelectDayViewController
        tv.parentTableview.reloadData()
        tv.viewWillAppear(true)*/
        self.loadDataOfDayWiseTimesheet(stringCheck: "GetDaywiseTimesheet")
       
    }
    //-------------function to change textview(using UITextview delegate), code starts---------
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
     //-------------function to change textview(using UITextview delegate), code ends---------

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
   
    @IBAction func onClickButtonTimesheetAction(_ sender: UIButton) {
        switch sender {
        case btnSubmit:
            openValidateSubmitFormPopup()
        case btnFormDialogCancel:
            cancelValidateSubmitFormPopup()
        case btnFormDialogSubmit:
            validatePasswordAndSubmit(stringCheck: "ValidatePassword",textField: tvPassword.text!)
        default:
            break
        }
    }
    
    @IBAction func onClickButton(_ sender: UIBarButtonItem) {
        switch sender {
        case btnMenuHome:
            print ("Success Home")
            self.performSegue(withIdentifier: "home", sender: self)
        case btnMenuBack:
            print("Success Back")
             self.performSegue(withIdentifier: "timesheetHome", sender: self)
        default:
            break
        }
    }
    
     //========================tableview code starts===================
    func TimesheetSelectDayTableViewCellDidTapAddOrView(_ sender: TimesheetSelectDayTableViewCell) {
        print("Tapped")
        guard let tappedIndexPath = parentTableview.indexPath(for: sender) else {return}
        let selectedSectionRowData = tableViewData[tappedIndexPath.section]
        let selectedDayHrs = tableViewData[tappedIndexPath.section].DayHrs[tappedIndexPath.row]
        UserSingletonModel.sharedInstance.weekDate = selectedSectionRowData.WeekDate
        UserSingletonModel.sharedInstance.dayDate = selectedDayHrs["DayDate"] as? String
        self.performSegue(withIdentifier: "timesheetWrkHrsUpdate", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hexFromString: "#2e5772")
        
       
        
        let labelWeekDateTitle = UILabel()
        labelWeekDateTitle.text = "Week Date"
        labelWeekDateTitle.numberOfLines = 1;
        labelWeekDateTitle.font = UIFont.boldSystemFont(ofSize: 12)
        labelWeekDateTitle.textColor = UIColor(hexFromString: "#ffffff")
        labelWeekDateTitle.adjustsFontSizeToFitWidth = true;
        labelWeekDateTitle.frame = CGRect(x:8, y:5, width: labelWeekDateTitle.intrinsicContentSize.width, height: 20)
        view.addSubview(labelWeekDateTitle)
        
        let labelWeekDayDate = UILabel()
        labelWeekDayDate.text = tableViewData[section].WeekDate
        labelWeekDayDate.numberOfLines = 1;
        labelWeekDayDate.font = UIFont.boldSystemFont(ofSize: 20)
        labelWeekDayDate.textColor = UIColor(hexFromString: "#ffffff")
        labelWeekDayDate.adjustsFontSizeToFitWidth = true;
        labelWeekDayDate.frame = CGRect(x:8, y:labelWeekDateTitle.fs_height+2, width: labelWeekDayDate.intrinsicContentSize.width, height: 35)
        view.addSubview(labelWeekDayDate)
        
        let labelWeekDayHours = UILabel()
        labelWeekDayHours.text = String(Double(tableViewData[section].TotalHours))
        labelWeekDayHours.numberOfLines = 1;
        labelWeekDayHours.font = UIFont.boldSystemFont(ofSize: 20)
        labelWeekDayHours.textColor = UIColor(hexFromString: "#ffffff")
        labelWeekDayHours.adjustsFontSizeToFitWidth = true;
        labelWeekDayHours.frame = CGRect(x:self.view!.bounds.width - labelWeekDayHours.intrinsicContentSize.width - 8, y:5, width: labelWeekDayHours.intrinsicContentSize.width, height: 35)
        view.addSubview(labelWeekDayHours)
        
        let labelWeekDayHoursTitle = UILabel()
        labelWeekDayHoursTitle.text = "Hour(s)"
        labelWeekDayHoursTitle.numberOfLines = 1;
        labelWeekDayHoursTitle.font = UIFont.boldSystemFont(ofSize: 12)
        labelWeekDayHoursTitle.textColor = UIColor(hexFromString: "#ffffff")
        labelWeekDayHoursTitle.adjustsFontSizeToFitWidth = true;
        labelWeekDayHoursTitle.frame = CGRect(x:self.view!.bounds.width - labelWeekDayHoursTitle.intrinsicContentSize.width - 8, y: labelWeekDayHours.fs_height+2, width: labelWeekDayHoursTitle.intrinsicContentSize.width, height: 20)
        view.addSubview(labelWeekDayHoursTitle)
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        /*   parentTableview.estimatedRowHeight = CGFloat((60 * tableViewData[section].DayHrs.count)+70)
         parentTableview.rowHeight = CGFloat((60 * tableViewData[section].DayHrs.count)+70)*/
        //        return arrResChild.count
        return  tableViewData[section].DayHrs.count
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectioncell") as! TimesheetSelectDayTableViewCell
        var dict = tableViewData[indexPath.section].DayHrs[indexPath.row]
//        print("table child index-->",dict)
        cell.delegate = self
        cell.viewSection.backgroundColor = UIColor(hexFromString: tableViewData[indexPath.section].ColorCode)
        let DayName = dict["DayName"] as? String
        if let dayName = DayName?.components(separatedBy: " ").first{
            cell.viewSectionDayName.text = dayName
        }
//        cell.viewSectionDayName.text = dict["DayName"] as? String
        cell.viewSectionDayHrs.text = String(Double(dict["Hours"] as! Int))
        cell.viewSectionDayDate.text = dict["DayDate"] as? String
        
        if ((UserSingletonModel.sharedInstance.timesheetStatusCode! == 4 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 2 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 5 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 7 ) && Double(dict["Hours"] as! Int) == 0) {
            cell.viewSectionImgAddorView.image = UIImage(named: "viewbtn.png")
        } else if ((UserSingletonModel.sharedInstance.timesheetStatusCode! == 4 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 2 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 5 || UserSingletonModel.sharedInstance.timesheetStatusCode! == 7 ) && Double(dict["Hours"] as! Int) != 0) {
           cell.viewSectionImgAddorView.image = UIImage(named: "viewbtn.png")
        } else if ((UserSingletonModel.sharedInstance.timesheetStatusCode! != 4 || UserSingletonModel.sharedInstance.timesheetStatusCode! != 2 || UserSingletonModel.sharedInstance.timesheetStatusCode! != 5 || UserSingletonModel.sharedInstance.timesheetStatusCode! != 7 ) && Double(dict["Hours"] as! Int) != 0) {
            cell.viewSectionImgAddorView.image = UIImage(named: "viewbtn.png")
        } else if ((UserSingletonModel.sharedInstance.timesheetStatusCode! != 4 || UserSingletonModel.sharedInstance.timesheetStatusCode! != 2 || UserSingletonModel.sharedInstance.timesheetStatusCode! != 5 || UserSingletonModel.sharedInstance.timesheetStatusCode! != 7 ) && Double(dict["Hours"] as! Int) == 0) {
            cell.viewSectionImgAddorView.image = UIImage(named: "addbtn.png")
        }
        return cell
    }
   
    //========================tableview code ends===================
    
    
    //=======================Validate_Submit function to open, close, cancel and save save popup code starts=================
    
    @IBOutlet var ViewFormDialogValidate: UIView!
    @IBOutlet weak var tvPassword: UITextField!
    @IBOutlet weak var labelValidationMessage: UILabel!
    @IBOutlet weak var btnFormDialogCancel: UIButton!
    @IBOutlet weak var btnFormDialogSubmit: UIButton!
    
   /* @IBAction func btnFormDialogSubmit(_ sender: Any) {
        validatePasswordAndSubmit(stringCheck: "ValidatePassword",textField: tvPassword.text!)
    }*/
    
    //===============FormDialogValidate openPopup function code starts=============
    func openValidateSubmitFormPopup(){
        blurEffect()
        self.view.addSubview(ViewFormDialogValidate)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        ViewFormDialogValidate.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        ViewFormDialogValidate.center = self.view.center
        ViewFormDialogValidate.layer.cornerRadius = 10.0
//        addGoalChildFormView.layer.cornerRadius = 10.0
        ViewFormDialogValidate.alpha = 0
        ViewFormDialogValidate.sizeToFit()
        
        UIView.animate(withDuration: 0.3){
            self.ViewFormDialogValidate.alpha = 1
            self.ViewFormDialogValidate.transform = CGAffineTransform.identity
        }
        labelValidationMessage.isHidden = true
        
    }
    //===============FormDialogValidate openPopup function code ends===============
    //------FormDialogValidate close popup code starts------
    func cancelValidateSubmitFormPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewFormDialogValidate.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.ViewFormDialogValidate.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.ViewFormDialogValidate.removeFromSuperview();
            self.canelBlurEffect()
        }
    }
    //-----FormDialogValidate close popup code ends-------
    
    
    //=======================Validate_Submit function to open, close, cancel and save save popup code ends=================
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
    // ====================== Blur Effect function calling code ends ================= \\
    
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
    func loadDataOfDayWiseTimesheet(stringCheck:String) {
        self.strCheck = stringCheck
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
    func validatePasswordAndSubmit(stringCheck:String, textField: String){
        self.strCheck = stringCheck
        
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><ValidatePassword xmlns='%@/'><UserType>%@</UserType><UserId>%@</UserId><Password>%@</Password><CompanyId>%@</CompanyId><CorpId>%@</CorpId></ValidatePassword></soap12:Body></soap12:Envelope>",BASE_URL, String(describing:UserSingletonModel.sharedInstance.UserType!), String(describing:UserSingletonModel.sharedInstance.UserID!),String(describing:textField), String(describing:"1"), String(describing:UserSingletonModel.sharedInstance.CorpID!))
        
        let soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=ValidatePassword")
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
    func submitData(stringCheck:String){
         self.strCheck = stringCheck
        let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><EmployeeTimesheetSubmit xmlns='%@/'><CorpID>%@</CorpID><UserId>%@</UserId><PeriodDate>%@</PeriodDate><EmployeeNote>%@</EmployeeNote><SupervisorNote>%@</SupervisorNote><UserType>%@</UserType><EmployeeType>%@</EmployeeType></EmployeeTimesheetSubmit></soap12:Body></soap12:Envelope>",BASE_URL, String(describing:UserSingletonModel.sharedInstance.CorpID!), String(describing:UserSingletonModel.sharedInstance.UserID!),String(describing:UserSingletonModel.sharedInstance.selectedDate!),String(describing:""),String(describing:""),String(describing:"EMPLOYEE"),String(describing:UserSingletonModel.sharedInstance.UserType!))
        
        let soapMessage = text
        let url = NSURL(string: "\(BASE_URL)/TimesheetService.asmx?op=EmployeeTimesheetSubmit")
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
        }
        if elementName == "ValidatePasswordResult"{
        self.ValidatePasswordResult = true
        }
        if elementName == "EmployeeTimesheetSubmitResult"{
            self.SubmitTimesheetData = true
        }
        /*else if elementName == "EmployeeTimesheetSubmitResult" {
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
        if self.strCheck == "GetDaywiseTimesheet"{
            if self.getDayWiseTimeSheetResult == true {
                
                if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do{
                    let response = try JSON(data: dataFromString)
                        print("getJsonDataforDate=-=->",response)
                    let status = response["status"].stringValue
                        if (status == "true"){
                            print("result--->","success")
                            UserSingletonModel.sharedInstance.periodStartDate = response["DayWiseTimeSheet"][0]["PeriodStartDate"].stringValue
                            
                            UserSingletonModel.sharedInstance.periodEndDate = response["DayWiseTimeSheet"][0]["PeriodEndDate"].stringValue
                            
                            tvPeriodDate.text = "("+UserSingletonModel.sharedInstance.periodStartDate+" - "+UserSingletonModel.sharedInstance.periodEndDate+")"
                            
                            UserSingletonModel.sharedInstance.timesheetStatusCode = response["DayWiseTimeSheet"][0]["statusCode"].intValue
                            //========code to set Status name and status color, starts============
                            if(response["DayWiseTimeSheet"][0]["statusCode"].intValue == 0){
                                tvStatus.text = "Not Started"
                                textViewDidChange(tvStatus)
                                viewStatusColor.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.NotStartedColor!)
                            }else if(response["DayWiseTimeSheet"][0]["statusCode"].intValue == 1){
                                tvStatus.text = "Saved"
                                textViewDidChange(tvStatus)
                                viewStatusColor.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.Saved!)
                            }else if(response["DayWiseTimeSheet"][0]["statusCode"].intValue == 2){
                                tvStatus.text = "Submitted"
                                textViewDidChange(tvStatus)
                                viewStatusColor.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.Submitted!)
                            }else if(response["DayWiseTimeSheet"][0]["statusCode"].intValue == 3){
                                tvStatus.text = "Returned"
                                textViewDidChange(tvStatus)
                                viewStatusColor.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.Returned!)
                            }else if(response["DayWiseTimeSheet"][0]["statusCode"].intValue == 4){
                                tvStatus.text = "Approved"
                                textViewDidChange(tvStatus)
                                viewStatusColor.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.Approved!)
                            }else if(response["DayWiseTimeSheet"][0]["statusCode"].intValue == 5){
                                tvStatus.text = "Posted"
                                textViewDidChange(tvStatus)
                                viewStatusColor.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.Posted!)
                            }else if(response["DayWiseTimeSheet"][0]["statusCode"].intValue == 6){
                                tvStatus.text = "Partially Returned"
                                textViewDidChange(tvStatus)
                                viewStatusColor.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.PartiallyReturned!)
                            }else if(response["DayWiseTimeSheet"][0]["statusCode"].intValue == 7){
                                tvStatus.text = "Partially Approved"
                                textViewDidChange(tvStatus)
                                viewStatusColor.backgroundColor = UIColor(hexFromString: UserSingletonModel.sharedInstance.PartiallyApproved!)
                            }
//                            userSingletonModel.setStatusDescription(tv_status.getText().toString()); //---6th june added text status
                            
                            //========code to set Status name and status color, ends============
                            //-----------------newly added(8th july)------------
                        
                            var getData = [String:AnyObject]()
                            
                           
                            for (key,value) in response["DayWiseTimeSheet"][0]["WeekDays"]{
                            var k = cellData()
                            var getData1 = [Any]()
                                print("jsonKeyData===>",key)
                                k.WeekDate = value["WeekDate"].stringValue
                                k.ColorCode = value["ColorCode"].stringValue
                                k.TotalHours = value["TotalHours"].intValue
                                UserSingletonModel.sharedInstance.colorCode = value["ColorCode"].stringValue
                              
                                for (key,value) in response["DayWiseTimeSheet"][0]["WeekDays"][(key as NSString).integerValue]["DayHrs"]{
                                    if value["ActiveYN"].stringValue == "true"{
                                        getData.updateValue(value["DayName"].stringValue as AnyObject, forKey: "DayName")
                                        getData.updateValue(value["Hours"].intValue as AnyObject, forKey: "Hours")
                                        getData.updateValue(value["DayDate"].stringValue as AnyObject, forKey: "DayDate")
                                        getData.updateValue(value["ActiveYN"].stringValue as AnyObject, forKey: "ActiveYN")
                                        getData1.append(getData)
                                       
                                    }
                                }
                                k.DayHrs = getData1 as! [[String:AnyObject]]
                                tableViewData.append(k)

                            }
                            if tableViewData.count>0{
                            parentTableview.reloadData()
                        
    
                            }
                             print("tableData jsontest--->",tableViewData)
                            print("childArraygetData---->==>",getData)
                            //-----------------newly added(8th july),ends------------
                            
                            if let resData = response["DayWiseTimeSheet"][0]["WeekDays"].arrayObject{
                                arrRes = resData as! [[String:AnyObject]]
                            }
//                            print("jsontestEmployee--->",arrRes)
                            
                            for (key,value) in JSON(response["DayWiseTimeSheet"][0]["WeekDays"]){
                            getAllData[key] = JSON(value) as AnyObject
                            }
//                            print("jsontest-->getAllDaTA-->",getAllData)
                            for (key,value) in JSON(getAllData["DayHrs"] as Any){
                            getAllData1[key] = JSON(value) as AnyObject
                            }
//                            print("jsontest-->getAlldata1child-->",getAllData1)
                            for index in 0...self.arrRes.count{
                                if let resData = response["DayWiseTimeSheet"][0]["WeekDays"][index]["DayHrs"].arrayObject{
//                                    arrResChild = resData as! [[String:AnyObject]]
                                    arrResChild.append(contentsOf: resData as! [[String:AnyObject]])
//                                    arrResChild.append(resData as! [[String : AnyObject]])
                                }
                                childSection = response["DayWiseTimeSheet"][0]["WeekDays"][index]["DayHrs"]

                            }

                        }

                    } catch let error
                    {
                        print(error)
                    }
                   
                    }
                }
    }
        if self.strCheck == "ValidatePassword"{
            if self.ValidatePasswordResult == true {
                
                if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do{
                        let response = try JSON(data: dataFromString)
                        print("ValidatePassword Result=-=->",response)
                        let status = response["status"].stringValue
                        if (status == "true"){
                            submitData(stringCheck: "SubmitTimesheetData")
                        }else if(status == "false"){
                           labelValidationMessage.isHidden = false
                           labelValidationMessage.text = response["message"].stringValue
                        }
                    }catch let error{
                    print(error)
                    }
                }
            }
        }
        if self.strCheck == "SubmitTimesheetData"{
            if self.SubmitTimesheetData == true {
                if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do{
                        let response = try JSON(data: dataFromString)
                        print("TimesheetSubmit Result=-=->",response)
                        cancelValidateSubmitFormPopup()
                        self.loadDataOfDayWiseTimesheet(stringCheck: "GetDaywiseTimesheet")
                        parentTableview.reloadData()
                    }catch let error{
                        print(error)
                    }
                }
            }
        }
            }
    
    }

//-----------hexacode color conversion---------
/*extension UIColor {
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
}*/
    

   
    

