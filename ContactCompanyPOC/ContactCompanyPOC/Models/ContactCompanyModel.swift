//
//  ContactCompanyModel.swift
//  ContactCompanyPOC
//
//  Created by Kapil Rathan on 6/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation

struct ContactCompanyList : Codable {
    public let contacts : [Contact]
    
    struct Contact: Codable{
        public let companyName: String?
        public let parent: String?
        public let name: String?
        public let phones: [String]?
        public let addresses: [String]?
        public let managers: [String]?
    }
    

    func searchEntities(name: String) -> [Contact] {
        var returnContacts: [Contact] = []
        for contact in contacts{
            if let companyName = contact.companyName, companyName.contains(name){
                returnContacts.append(contact)
            }else if let contactName = contact.name?.contains(name), contactName == true{
                returnContacts.append(contact)
            }
        }
        return returnContacts
    }
    
    func getRelatedEntities(currentContact: ContactCompanyList.Contact) -> [Contact] {
        var returnContacts: [Contact] = []
        for contact in contacts{
            if let parent = contact.parent, parent == currentContact.companyName{
                returnContacts.append(contact)
            }else if let managers = contact.managers, let name = currentContact.name, managers.contains(name){
                 returnContacts.append(contact)
            }else if let companyName = contact.companyName, let parent = currentContact.parent, companyName == parent{
                 returnContacts.append(contact)
            }else if let name = contact.name, let managers = currentContact.managers, managers.contains(name){
                returnContacts.append(contact)
            }
        }
        return returnContacts
    }
}
