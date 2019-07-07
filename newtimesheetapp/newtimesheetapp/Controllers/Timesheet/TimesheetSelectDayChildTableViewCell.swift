//
//  TimesheetSelectDayChildTableViewCell.swift
//  newtimesheetapp
//
//  Created by User on 05/07/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit

protocol TimesheetSelectDayChildTableViewCellDelegate : class {
    func TimesheetSelectDayChildTableViewCellDidTapAddOrView(_ sender: TimesheetSelectDayChildTableViewCell)
}

class TimesheetSelectDayChildTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewAddOrView: UIImageView!
    @IBOutlet weak var viewChild: UIView!
    @IBOutlet weak var tvWeekDayName: UITextView!
    @IBOutlet weak var tvWeekDayHours: UITextView!
    @IBOutlet weak var tvWeekDayDate: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imgViewAddOrViewTapped(tapGestureRecognizer:)))
        imgViewAddOrView.isUserInteractionEnabled = true
        imgViewAddOrView.addGestureRecognizer(tapGestureRecognizer)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    weak var delegate: TimesheetSelectDayChildTableViewCellDelegate?
    @objc func imgViewAddOrViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        delegate?.TimesheetSelectDayChildTableViewCellDidTapAddOrView(self)
        
    }

}
