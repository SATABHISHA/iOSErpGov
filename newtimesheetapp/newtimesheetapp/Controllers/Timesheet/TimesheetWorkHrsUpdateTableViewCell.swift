//
//  TimesheetWorkHrsUpdateTableViewCell.swift
//  newtimesheetapp
//
//  Created by User on 13/07/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit

class TimesheetWorkHrsUpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewChild: UIView!
    @IBOutlet weak var labelWrkHrsUpdateGlCode: UILabel!
    @IBOutlet weak var labelWrkHrsUpdateTaskDescription: UILabel!
    @IBOutlet weak var labelWrkHrsUpdateLabourType: UILabel!
    @IBOutlet weak var tvWrkHrsAddHrs: UITextField!
    var textChanged: ((String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
