//
//  Constants.swift
//  RecordingApp
//
//  Created by Nguyen Huu Thao on 6/18/21.
//

import Foundation
struct Constants {
    //MARK: - Image Name Asset
    static let recordImage          = "record"
    static let pauseImage           = "pause"
    static let settingImage         = "setting"
    static let faqImage             = "faq"
    static let menuImage            = "menu"
    static let flagImage            = "flag"
    static let checkImage           = "check"
    static let iconPlayImage        = "iconplay"
    static let playBack3s           = "playBack3s"
    static let playNext3s           = "playNext3s"
    //MARK: - Controller Name
    static let recordingController = "Recording"
    struct Controller {
        static let listRecordController = "ListRecordController"
    }
    struct TableCell {
        static let listRecordCell_Indentifier = "RecordCells"
    }
    
    static func getDayMonthYearFromDate(date : Date) -> (Int,Int,Int)
    {
        let calender = Calendar.current
        let components = calender.dateComponents([.year, .month, .day], from: date)
        guard let day = components.day,let month = components.month,let year = components.year else {
            return (0,0,0)
        }
        return (day,month,year)
    }
    
    
    static func getDocumentPath() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask )
        return path[0]
    }
    
}
