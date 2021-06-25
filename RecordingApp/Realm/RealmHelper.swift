//
//  RealmManager.swift
//  RecordingApp
///Users/nguyenhuuthao/Desktop/MyProject/RecordingApp/RecordingApp/Model/Record.swift
//  Created by Nguyen Huu Thao on 6/22/21.
//


import Foundation
import RealmSwift
class RealmHelper{
    //Insert new Object to Realm
    static func insert(filename :String,duration:Int,createDate:Date) {
        let realm = try! Realm()
        
        try! realm.write {
            var record = Record()
            record.fileName     = filename
            record.duration     = duration
            record.createDate   = createDate
            if realm.objects(Record.self).filter("fileName =%@",filename).first != nil{
                return
            }
            realm.add(record)
        }
        print("Success full Save in Realm")
        print("Path to realm file: " + realm.configuration.fileURL!.absoluteString)
    }
    //Get listobject -> Array
    static func getObjects()->[Record] {
       let realm = try! Realm()
       let realmResults = realm.objects(Record.self)
       return Array(realmResults)

    }
    //Get List Object with filer -> Array
    static func getObjects(filter:String)->[Record] {
       let realm = try! Realm()
       let realmResults = realm.objects(Record.self).filter(filter)
       return Array(realmResults)

    }
    static func remove(newId:String)
    {
        let realm = try! Realm()
        if let obj = realm.objects(Record.self).filter("fileName = %@", newId).first {
            try! realm.write{
                realm.delete(obj)
            }
        }
        print("Delete Success")
    }
    static func removeAll()
    {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
}
