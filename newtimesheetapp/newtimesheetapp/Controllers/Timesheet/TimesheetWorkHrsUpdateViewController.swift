//
//  TimesheetWorkHrsUpdateViewController.swift
//  newtimesheetapp
//
//  Created by User on 13/07/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit

class TimesheetWorkHrsUpdateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableviewWorkHrsUpdate: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
        /*   parentTableview.estimatedRowHeight = CGFloat((60 * tableViewData[section].DayHrs.count)+70)
         parentTableview.rowHeight = CGFloat((60 * tableViewData[section].DayHrs.count)+70)*/
        //        return arrResChild.count
//        return  tableViewData[section].DayHrs.count
        return 10
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TimesheetWorkHrsUpdateTableViewCell
       
        return cell
    }
    
    //========================tableview code ends===================

}
