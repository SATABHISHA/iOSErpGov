//
//  TimesheetSelectDayTableViewCell.swift
//  newtimesheetapp
//
//  Created by User on 05/07/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit

protocol TimesheetSelectDayTableViewCellDelegate : class {
    func TimesheetSelectDayTableViewCellDidTapAddOrView(_ sender: TimesheetSelectDayTableViewCell)
}
class TimesheetSelectDayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewSection: UIView!
    
    @IBOutlet weak var viewSectionDayName: UITextView!
    
    @IBOutlet weak var viewSectionDayDate: UITextView!
    
    @IBOutlet weak var viewSectionDayHrs: UITextView!
    
    @IBOutlet weak var imgViewAddOrView: UIImageView!
    @IBOutlet weak var viewSectionImgAddorView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewSectionDayName.isEditable = false
        viewSectionDayDate.isEditable = false
        viewSectionDayHrs.isEditable = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imgViewAddOrViewTapped(tapGestureRecognizer:)))
        imgViewAddOrView.isUserInteractionEnabled = true
        imgViewAddOrView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: TimesheetSelectDayTableViewCellDelegate?
    @objc func imgViewAddOrViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.TimesheetSelectDayTableViewCellDidTapAddOrView(self)
        
    }

}

