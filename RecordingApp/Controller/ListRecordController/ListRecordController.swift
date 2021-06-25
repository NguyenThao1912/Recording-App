//
//  ListRecordController.swift
//  RecordingApp
//
//  Created by Nguyen Huu Thao on 6/22/21.
//

import UIKit

class ListRecordController: BaseViewController {

    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!

    var recordData      =  [RecordView]()
    var totalrecord     : Int?
    var isSearchActive  = false
    
    var filteredData    : [Record]!
    {
        didSet{
            recordTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        setupUI()
        setupData()
    }
    
    override func setupUI() {
        self.title = "Danh sach"
        // Do any additional setup after loading the view.
        recordTableView.delegate        = self
        recordTableView.dataSource      = self
        searchBar.delegate              = self
        searchBar.placeholder = "Type here to search"
        let recordCellNib = UINib(nibName: "ListRecordTableViewCell", bundle: nil)
        recordTableView.register(recordCellNib, forCellReuseIdentifier: Constants.TableCell.listRecordCell_Indentifier)
    }
    
    override func setupData() {
        
        print("start fetching data")
        getAndClassifyData()
    }
    
    func getAndClassifyData()  {
        var currentSection = 0
        var recordView = [Record]()
        let rawData = RealmHelper.getObjects().sorted { (item1, item2) -> Bool in
            return item1.createDate > item2.createDate
        }
        if rawData.count > 0{
            var date = rawData[0].getYearMonthCreate()
           
            for index in 0..<rawData.count {
                if rawData[index].getYearMonthCreate() != date {
                    let newRecordView = RecordView(records: recordView, section: currentSection)
                    recordData.append(newRecordView)
                    date = rawData[index].getYearMonthCreate()
                    currentSection += 1
                    recordView.removeAll()
                }
                else{
                    recordView.append(rawData[index])
                }
            }
            
            if recordView.count > 0{
                let newRecordView = RecordView(records: recordView, section: currentSection)
                recordData.append(newRecordView)
                recordView.removeAll()
            }
        }
        else{
            return
        }
        print(rawData.count)
    }

}

extension ListRecordController : UISearchBarDelegate{
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredData = RealmHelper.getObjects(filter: "fileName contains '\(searchText)'")
//        isSearchActive = true
//    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearchActive = false
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        isSearchActive = true
//    }
//

}
extension ListRecordController : UITableViewDelegate , UITableViewDataSource{
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCell.listRecordCell_Indentifier, for: indexPath) as! ListRecordTableViewCell
        cell.record = recordData[indexPath.section].records[indexPath.row]
        cell.setData()
        
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return recordData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordData[section].records.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Constants.getDayMonthYearFromDate(date: Date())
        return "tháng \(date.1) \(date.2)"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.backgroundColor = .clear
        
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playRecordController = PlayRecordController()
        playRecordController.currentRecord = recordData[indexPath.section].records[indexPath.row]
        
        
        navigationController?.pushViewController(playRecordController, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var selectRecord : Record
            selectRecord = recordData[indexPath.section].records[indexPath.row]
            
            
            let path = Constants.getDocumentPath().appendingPathComponent("\(selectRecord.fileName).m4a").path
            recordData[indexPath.section].records.remove(at: indexPath.row)
            Constants.removeFileAt(path: path)
            RealmHelper.remove(newId: selectRecord.fileName)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
           // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}
