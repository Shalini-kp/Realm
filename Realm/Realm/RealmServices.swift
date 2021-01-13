//
//  RealmServices.swift
//

import UIKit
import RealmSwift

class RealmServices {

    private init() {}
    static var shared = RealmServices()
    
    //connect to database
    func connectRealm() -> Realm? {
        do {
            return try Realm()
        } catch {
            print("Not able to connect to realm")
            return nil
        }
    }
    
    //create
    func create<T: Object>(_ object: T) {
        do {
            try connectRealm()?.write {
                connectRealm()?.add(object, update: true)
            }
        } catch {
            print("\n error while creating")
        }
    }
    
    //fetch
    func fetch<T: Object>(_ object: T.Type) -> Results<T>? {
        return connectRealm()?.objects(object)
    }
    
    //check whether the object exists or not
    func isExist<T: Object>(_ object: T.Type) -> Bool {
        return (((connectRealm()?.objects(object)) != nil))
    }
    
    //update
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try connectRealm()?.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print("\n error while updating")
        }
    }
    
    //delete
    func delete<T: Object>(_ object: T) {
        do {
            try connectRealm()?.write {
                connectRealm()?.delete(object)
            }
        } catch {
            print("\n error while deleting")
        }
    }
    
    //delete all
    func deleteAll() {
        do {
            try connectRealm()?.write {
                connectRealm()?.deleteAll()
            }
        } catch {
            print("\n error while deleting all")
        }
    }
}

//Structure of data
class MasterData: Object {

    @objc dynamic var entityId = ""
    @objc dynamic var entityName: String? = nil
    @objc dynamic var entityType: String? = nil
    @objc dynamic var parentId: String? = nil
   
    //parameterized constructor
    convenience required init(_ entityId: String,_ entityName: String?,_ entityType: String?,_ parentId: String?){
        
        self.init()
        self.entityId = entityId
        self.entityName = entityName
        self.entityType = entityType
        self.parentId = parentId
    }
    
    //set unique value (avoid duplication)
    override static func primaryKey() -> String? {
        return "entityId"
    }
}
