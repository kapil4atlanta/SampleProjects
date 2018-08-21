//
//  DataManager.swift
//  ContactCompanyPOC
//
//  Created by Kapil Rathan on 6/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation

enum Urls: String {
    case ContactsDataHost = "https://api.myjson.com/bins/jz6bp"
    
}

class ContactsDataManager: NSObject {
    
    public static let shared = ContactsDataManager()
    private var contactsObject: ContactCompanyList?
    
    
    public func getContactsObject() -> ContactCompanyList?{
        if self.contactsObject != nil{
            return self.contactsObject
        }
        return nil
    }
    
    override init(){
        super.init()
    }
    
    
    public func getContactsData(completion: @escaping (Bool) -> Void){
        
        //Fetch All Contacts
        
        HttpHandler.fetchCompanyData(urlString: Urls.ContactsDataHost.rawValue) { [weak self] (data, error) in
            guard let strongSelf = self else { return }
            
            if error != nil{
                completion(false)
            }
            else{
                
                guard let data = data else{
                    return
                }
                
                do{
                    let decoder = JSONDecoder()
                    let scheduleObject = try decoder.decode(ContactCompanyList.self, from: data)
                    strongSelf.contactsObject = scheduleObject
                    
                    if strongSelf.contactsObject != nil{
                        completion(true)
                    }
                    
                }catch let error{
                    print (error)
                }
            }
        }
        
    }
}


