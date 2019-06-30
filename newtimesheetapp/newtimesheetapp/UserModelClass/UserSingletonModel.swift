//
//  UserSingletonModel.swift
//  newtimesheetapp
//
//  Created by User on 28/06/19.
//  Copyright © 2019 Arb Investment. All rights reserved.
//

import Foundation

class UserSingletonModel: NSObject {
    static let sharedInstance = UserSingletonModel()
    
    //------variables for login-------
    var PayrollClerkYN:Int!
    var UserType:String!
    var CorpID:String!
    var AdminYN:Int!
    var Msg:String!
    var PwdSetterId:Int!
    var EmpName:String!
    var UserRole:String!
    var SupervisorId:Int!
    var UserID:Int!
    var CompID:Int!
    var PayableClerkYN:Int!
    var UserName:String!
    var CompanyName:String!
    var FinYearID:String!
    var SupervisorYN:Int!
    var PurchaseYN:Int!
    var EmailId:String!
    

}
