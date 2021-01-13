//
//  MasterDataViewController.swift
//  RealmDatabase
//
//

import UIKit
import RealmSwift

class MasterDataViewController: UIViewController {
    
    @IBOutlet weak var masterDataTableView: UITableView!
    
    var masterDataList: Results<MasterData>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load data from local (if want to get it from API, -- make use of ServiceRequestResponse class --)
        let url = Bundle.main.url(forResource: "MasterData", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        guard data != nil else { return }
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            
            if let jsonData = object as? NSArray {
                
                let startDate = Date()
                self.masterData(jsonData , completion: {
                    let executionTime = Date().timeIntervalSince(startDate)
                    print("Realm executionTime =>\(executionTime)")
                })
            }
        } catch {
            print("Json parser error")
        }
    }
    
    //master data
    func masterData(_ jsonData: NSArray, completion: @escaping () -> ())
    {
        DispatchQueue.main.async {
            
            for i in jsonData {
                let dictionaryObj = i as! Dictionary<String, Any>
                
                let masterData = MasterData(dictionaryObj["_id"] as! String,dictionaryObj["name"] as? String, dictionaryObj["entityType"] as? String, (dictionaryObj["parentId"] as? String))
                
                RealmServices.shared.create(masterData)
            }
            self.masterDataList = RealmServices.shared.fetch(MasterData.self)
            self.masterDataTableView.reloadData()
            completion()
        }
    }
}

extension MasterDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masterDataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "masterDataTableViewCellID")
        cell.textLabel?.text = masterDataList?[indexPath.row].entityName
        return cell
    }
}

