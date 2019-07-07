//
//  TimesheetSelectDayTableViewCell.swift
//  newtimesheetapp
//
//  Created by User on 05/07/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import UIKit

class TimesheetSelectDayTableViewCell: UITableViewCell {
    @IBOutlet weak var tvTitleofWkDt: UITextView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var insideTableView: UITableView!
    @IBOutlet weak var tvTitleWeekDateHours: UITextView!
    @IBOutlet weak var tvTitleWeekDate: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension TimesheetSelectDayTableViewCell{
    func selectTableViewDataSourceDelegate<D:UITableViewDelegate & UITableViewDataSource>
        (_ dataSourceDelegate: D, forRow row: Int)
    {
        insideTableView.delegate = dataSourceDelegate
        insideTableView.dataSource = dataSourceDelegate
        insideTableView.reloadData()
    }
   
}
