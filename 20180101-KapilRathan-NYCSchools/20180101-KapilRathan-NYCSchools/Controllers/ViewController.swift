//
//  ViewController.swift
//  20180101-KapilRathan-NYCSchools
//
//  Created by Kapil Rathan on 8/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{
    
    var detailsVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New York Schools"

        // Do any additional setup after loading the view, typically from a nib.
        SchoolDataManager.shared.getSchoolListData { (result) in
            if result{
                self.tableView.reloadData()
            }else{
                let alertVC = UIAlertController.init(title: "No Data Available", message: "Please try Again", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        SchoolDataManager.shared.getSchoolDetails { (result) in

        }
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let schoolsList = SchoolDataManager.shared.getSchoolListObject(), let schools = schoolsList.schools{
            return schools.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let schoolsList = SchoolDataManager.shared.getSchoolListObject(), let schools = schoolsList.schools {
            let schoolObject = schools[indexPath.row]
            cell?.textLabel?.text = schoolObject.school_name
            cell?.detailTextLabel?.text = schoolObject.primary_address_line_1 + ", " + schoolObject.city + ", " + schoolObject.state_code + ", " + schoolObject.zip
            
        }
        
        return cell!
       
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue", let detailVC = segue.destination as? SchoolDetailViewController {
            
            if let schoolsList = SchoolDataManager.shared.getSchoolListObject(), let schools = schoolsList.schools, let schoolsDescriptions = SchoolDataManager.shared.getSchoolDetailsObject(), let indexPath = self.tableView.indexPathForSelectedRow{
                let dbn = schools[indexPath.row].dbn
                let schoolDesc = schoolsDescriptions.getSchoolDescriptionfromDBN(dbn: dbn)
                detailVC.schoolDesc = schoolDesc
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }

        }
    }
}
