//
//  Constants.File.swift
//  RecordingApp
//
//  Created by Nguyen Huu Thao on 6/23/21.
//

import Foundation
extension Constants{
    static func changeFileName(newFileName : String,currentURL : URL)  {
        let nsfile = FileManager.init()
        let newURLFile = Constants.getDocumentPath().appendingPathComponent("\(newFileName).m4a")
        if nsfile.fileExists(atPath: newURLFile.path) {
            removeFileAt(path: newURLFile.path)
        }
        do{
            _ = try nsfile.moveItem(at: currentURL, to: newURLFile)
        }
        catch{
            
        }
        if nsfile.fileExists(atPath: currentURL.path) {
            removeFileAt(path: currentURL.path)
        }
       
    }
    
    static func removeFileAt(path : String)  {
        let nsfile = FileManager.init()
        do {
            try nsfile.removeItem(atPath: path)
        }catch{
            print(error)
        }
    }
}
