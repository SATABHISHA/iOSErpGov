//
//  HomeController.swift
//  newtimesheetapp
//
//  Created by User on 28/06/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var btnTimesheet: UIButton!
    @IBOutlet weak var btnPendingItems: UIButton!
    @IBOutlet weak var btnAnnouncements: UIButton!
    @IBOutlet weak var btnUpcomingEvents: UIButton!
    @IBOutlet weak var btnLeaveBalance: UIButton!
    @IBOutlet weak var btnVacationRequest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

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
