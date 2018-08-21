//
//  DetailViewController.swift
//  ContactCompanyPOC
//
//  Created by Kapil Rathan on 6/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactCompany: UILabel!
    @IBOutlet weak var contactParent: UILabel!
    
    @IBOutlet weak var contactManagers: UILabel!
    
    @IBOutlet weak var contactPhones: UILabel!
    
    @IBOutlet weak var contactAddresses: UILabel!
    
    var currentContact:ContactCompanyList.Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        title = "Entity Details"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if let currentContact = currentContact{
            self.contactName.text = currentContact.name
            self.contactCompany.text = currentContact.companyName
            self.contactParent.text = currentContact.parent
            if let managers = currentContact.managers{
                var managersText = ""
                var counter = 0
                for manager in managers{
                    if counter > 0 {
                        managersText.append(", ")
                    }
                    managersText.append(manager)
                    counter = counter + 1
                }
                self.contactManagers.text = managersText
            }
            
            if let phones = currentContact.phones{
                var phonesText = ""
                var counter = 0
                for phone in phones{
                    if counter > 0 {
                        phonesText.append(", ")
                    }
                    phonesText.append(phone)
                    counter = counter + 1
                }
                self.contactPhones.text = phonesText
            }
            
            if let addresses = currentContact.addresses{
                var addressText = ""
                var counter = 0
                for address in addresses{
                    if counter > 0 {
                        addressText.append(", ")
                    }
                    addressText.append(address)
                    counter = counter + 1
                }
                self.contactAddresses.text = addressText
            }
        }
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedOnRelatedEntities(_ sender: Any) {
//
//        self.performSegue(withIdentifier: "RelatedSgIdentifier", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentContact = self.currentContact, let list = ContactsDataManager.shared.getContactsObject() else {
            return
        }
        
        if  segue.identifier == "RelatedSgIdentifier",
            let destination = segue.destination as? RelatedViewController{
            
             destination.relatedEntites =  list.getRelatedEntities(currentContact: currentContact)
        }
    }

}
