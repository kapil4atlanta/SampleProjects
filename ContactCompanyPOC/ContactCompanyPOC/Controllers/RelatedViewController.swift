//
//  DetailViewController.swift
//  ContactCompanyPOC
//
//  Created by Kapil Rathan on 6/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import UIKit

class RelatedViewController: UIViewController {
    @IBOutlet weak var detailTableView: UITableView!
    
    var relatedEntites: [ContactCompanyList.Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        title = "Related Entities"

        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
    }

}

extension RelatedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedEntites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        var cellText = ""
        guard self.relatedEntites.count > 0 else {
            return cell
        }
        
        if let companyName = relatedEntites[indexPath.row].companyName{
            cellText = companyName
        }else if let name = relatedEntites[indexPath.row].name{
            cellText = name
        }
        cell.textLabel?.text = cellText
        return cell
    }
}
extension RelatedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
