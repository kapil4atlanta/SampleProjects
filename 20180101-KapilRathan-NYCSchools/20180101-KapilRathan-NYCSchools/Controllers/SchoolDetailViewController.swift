//
//  schoolDetailViewController.swift
//  20180101-KapilRathan-NYCSchools
//
//  Created by Kapil Rathan on 8/20/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import UIKit

class SchoolDetailViewController: UITableViewController {

    @IBOutlet var detailTableView: UITableView!
    var schoolDesc: SchoolDescription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "School"
        self.detailTableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if schoolDesc == nil{
            let alertVC = UIAlertController.init(title: "No Data Available", message: "Please go back and try Another School", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = schoolDesc{
            return 1
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! detailCell
        // Configure the cell...
        if let schoolDesc = schoolDesc{
            cell.schoolName.text = schoolDesc.school_name
            cell.mathsSAT.text = schoolDesc.sat_math_avg_score
            cell.readingSAT.text = schoolDesc.sat_critical_reading_avg_score
            cell.writingSAT.text = schoolDesc.sat_writing_avg_score
        }
        return cell
    }
}


class detailCell: UITableViewCell{
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var mathsSAT: UILabel!
    @IBOutlet weak var writingSAT: UILabel!
    @IBOutlet weak var readingSAT: UILabel!
}
