//
//  HomeController.swift
//  newtimesheetapp
//
//  Created by User on 28/06/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HomeController: UIViewController, XMLParserDelegate {

    @IBOutlet weak var btnTimesheet: UIButton!
    @IBOutlet weak var btnPendingItems: UIButton!
    @IBOutlet weak var btnAnnouncements: UIButton!
    @IBOutlet weak var btnUpcomingEvents: UIButton!
    @IBOutlet weak var btnLeaveBalance: UIButton!
    @IBOutlet weak var btnVacationRequest: UIButton!
    var mutableData = NSMutableData()
    
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var parser = XMLParser()
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.getStatusColor()
       
        // Do any additional setup after loading the view.
        let url:String="http://220.225.40.151:9012/TimesheetService.asmx/SubordinateListTimeSheetStatus"
        let urlToSend: URL = URL(string: url)!
        // Parse the XML
        parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
            print(strXMLData)
            
//            lblNameData.text=strXMLData
            
        } else {
            print("parse failure!")
        }
        
    }
        //=============xml parser code starts==========
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            currentElement=elementName;
         /*   if(elementName=="id" || elementName=="name" || elementName=="cost" || elementName=="description")
            {
                if(elementName=="name"){
                    passName=true;
                }
                passData=true;
            }*/
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            currentElement="";
          /*  if(elementName=="id" || elementName=="name" || elementName=="cost" || elementName=="description")
            {
                if(elementName=="name"){
                    passName=false;
                }
                passData=false;
            }*/
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            if(passName){
                strXMLData=strXMLData+"\n\n"+string
            }
            
            if(passData)
            {
                print(string)
            }
        }
        
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
            print("failure error: ", parseError)
        }
        //=============xml parser code ends========
    
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
   /* func getStatusColor(){
       let url = "http://220.225.40.151:9012/TimesheetService.asmx/SubordinateListTimeSheetStatus"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseString { response in
                debugPrint(response)
                
                if let data = response.result.value{
                    // Response type-1
                    print(data)
                    let data = JSONSerialization
                }
        }
    }*/

}

