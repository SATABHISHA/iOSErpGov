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
    }
    
    @IBAction func btnOnClick(_ sender: UIButton) {
        switch sender {
        case btnTimesheet:
            print ("Success Timesheet")
            if(UserSingletonModel.sharedInstance.SupervisorYN == 0 && UserSingletonModel.sharedInstance.PayrollClerkYN == 0 &&
                UserSingletonModel.sharedInstance.PayableClerkYN == 0){
                self.performSegue(withIdentifier: "timesheetHomeSegue", sender: self)
                UserSingletonModel.sharedInstance.EmployeeYN = 1
                UserSingletonModel.sharedInstance.supervisor_yn_temp = 0
                UserSingletonModel.sharedInstance.payrollclerk_yn_temp = 0
                UserSingletonModel.sharedInstance.payableclerk_yn_temp = 0
            }else{
                openTimesheetSelectionPopup()
            }
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
    
    
    //===============FormDialogValidate openPopup function code starts=============
    
  
    @IBOutlet var FormViewChooseTimesheetPopup: UIView!
    @IBOutlet weak var FormViewChildEmployee: UIView!
    @IBOutlet weak var FormViewChildSupervisor: UIView!
    @IBOutlet weak var FormViewChildPayrollOperator: UIView!
    @IBOutlet weak var FormViewChildPayableOperator: UIView!
    func openTimesheetSelectionPopup(){
        blurEffect()
        self.view.addSubview(FormViewChooseTimesheetPopup)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.height
        FormViewChooseTimesheetPopup.transform = CGAffineTransform.init(scaleX: 1.3,y :1.3)
        FormViewChooseTimesheetPopup.center = self.view.center
        FormViewChooseTimesheetPopup.layer.cornerRadius = 10.0
        //        addGoalChildFormView.layer.cornerRadius = 10.0
        FormViewChooseTimesheetPopup.alpha = 0
        FormViewChooseTimesheetPopup.sizeToFit()
        
        UIView.animate(withDuration: 0.3){
            self.FormViewChooseTimesheetPopup.alpha = 1
            self.FormViewChooseTimesheetPopup.transform = CGAffineTransform.identity
        }
        if (UserSingletonModel.sharedInstance.SupervisorYN == 1 && UserSingletonModel.sharedInstance.PayrollClerkYN == 1 && UserSingletonModel.sharedInstance.PayableClerkYN == 1) {
            FormViewChildEmployee.isHidden = false
            FormViewChildSupervisor.isHidden = false
            FormViewChildPayrollOperator.isHidden = false
            FormViewChildPayableOperator.isHidden = false
        } else if (UserSingletonModel.sharedInstance.SupervisorYN == 0 && UserSingletonModel.sharedInstance.PayrollClerkYN == 1 && UserSingletonModel.sharedInstance.PayableClerkYN == 1) {
            FormViewChildEmployee.isHidden = false
            FormViewChildSupervisor.isHidden = true
            FormViewChildPayrollOperator.isHidden = false
            FormViewChildPayableOperator.isHidden = false
        } else if (UserSingletonModel.sharedInstance.SupervisorYN == 1 && UserSingletonModel.sharedInstance.PayrollClerkYN == 0 && UserSingletonModel.sharedInstance.PayableClerkYN == 1) {
            FormViewChildEmployee.isHidden = false
            FormViewChildSupervisor.isHidden = false
            FormViewChildPayrollOperator.isHidden = true
            FormViewChildPayableOperator.isHidden = false
        } else if (UserSingletonModel.sharedInstance.SupervisorYN == 1 && UserSingletonModel.sharedInstance.PayrollClerkYN == 1 && UserSingletonModel.sharedInstance.PayableClerkYN == 0) {
            FormViewChildEmployee.isHidden = false
            FormViewChildSupervisor.isHidden = false
            FormViewChildPayrollOperator.isHidden = false
            FormViewChildPayableOperator.isHidden = true
        } else if (UserSingletonModel.sharedInstance.SupervisorYN == 1 && UserSingletonModel.sharedInstance.PayrollClerkYN == 0 && UserSingletonModel.sharedInstance.PayableClerkYN == 0) {
            FormViewChildEmployee.isHidden = false
            FormViewChildSupervisor.isHidden = false
            FormViewChildPayrollOperator.isHidden = true
            FormViewChildPayableOperator.isHidden = true
        } else if (UserSingletonModel.sharedInstance.SupervisorYN == 0 && UserSingletonModel.sharedInstance.PayrollClerkYN == 1 && UserSingletonModel.sharedInstance.PayableClerkYN == 0) {
            FormViewChildEmployee.isHidden = false
            FormViewChildSupervisor.isHidden = true
            FormViewChildPayrollOperator.isHidden = false
            FormViewChildPayableOperator.isHidden = true
        } else if (UserSingletonModel.sharedInstance.SupervisorYN == 0 && UserSingletonModel.sharedInstance.PayrollClerkYN == 0 && UserSingletonModel.sharedInstance.PayableClerkYN == 1) {
            FormViewChildEmployee.isHidden = false
            FormViewChildSupervisor.isHidden = true
            FormViewChildPayrollOperator.isHidden = true
            FormViewChildPayableOperator.isHidden = false
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(formViewChildEmployee(tapGestureRecognizer:)))
        FormViewChildEmployee.isUserInteractionEnabled = true
        FormViewChildEmployee.addGestureRecognizer(tapGestureRecognizer)
        
       
        
    }
    @objc func formViewChildEmployee(tapGestureRecognizer: UITapGestureRecognizer)
    {
       self.performSegue(withIdentifier: "timesheetHomeSegue", sender: self)
        UserSingletonModel.sharedInstance.EmployeeYN = 1
        UserSingletonModel.sharedInstance.supervisor_yn_temp = 0
        UserSingletonModel.sharedInstance.payrollclerk_yn_temp = 0
        UserSingletonModel.sharedInstance.payableclerk_yn_temp = 0
    }
    //===============FormDialogValidate openPopup function code ends===============
    //------FormDialogValidate close popup code starts------
    func cancelSaveFormPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.FormViewChooseTimesheetPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.FormViewChooseTimesheetPopup.alpha = 0
            self.blurEffectView.alpha = 0.3
        }) { (success) in
            self.FormViewChooseTimesheetPopup.removeFromSuperview();
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
        let blurEffect = UIBlurEffect(style: .dark)
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
