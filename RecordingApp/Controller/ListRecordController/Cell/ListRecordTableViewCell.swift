//
//  ListRecordTableViewCell.swift
//  RecordingApp
//
//  Created by Nguyen Huu Thao on 6/22/21.
//

import UIKit

class ListRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var playImage        : UIImageView!
    
    @IBOutlet weak var fileName         : UILabel!
    @IBOutlet weak var fileCreateDate   : UILabel!
    @IBOutlet weak var fileDuration     : UILabel!
    
    var record : Record?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(){
        guard let record = record else {
            return
        }
        let duration    = record.getDuration()
        let date        = record.getYearMonthCreate()
        let day         = Calendar.current.component(.day, from: record.createDate)
        fileCreateDate.text    =   "\(day)/\(date.0)/\(date.1)"
        fileDuration.text      =   String(format: "%.2d:%.2d", arguments: [duration.0,duration.1])
        fileName.text          =   record.fileName
    }
    
}
