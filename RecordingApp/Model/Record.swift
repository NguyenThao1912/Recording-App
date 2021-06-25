//
//  Record.swift
//  RecordingApp
//
//  Created by Nguyen Huu Thao on 6/21/21.
//

import Foundation
import RealmSwift
class Record : Object {
   
    @objc dynamic var createDate : Date     = Date()
    @objc dynamic var duration   : Int      = 0
    @objc dynamic var fileName   : String   = ""
    
    override class func primaryKey() -> String? {
        return "fileName"
    }
    
    func getDuration() -> (Int,Int) {
        let minutes = duration / 60
        let second  = duration % 60
        return (minutes,second)
    }
    
    func getYearMonthCreate() -> (Int,Int) {
        let date = Constants.getDayMonthYearFromDate(date: createDate)
        return (date.1,date.2)
    }
    
}
