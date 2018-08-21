//
//  ViewController.swift
//  Bluetooth_LowEnergyDemo
//
//  Created by Kapil Rathan on 5/1/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import UIKit
import UserNotifications
import CoreBluetooth

enum SelectedManager: String{
    case Peripheral = "Peripheral Device"
    case Central = "Central Device"
}

enum StartStopButtons: String{
    case PeripheralStart = "Start Advertising"
    case PeripheralStop = "Stop Advertising"
    case CentralStart = "Start Scanning"
    case CentralStop = "Stop Scanning"
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CentralDelegate, PeripheralDelegate {
    
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var bluetoothPowerStatus: UISwitch!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var managerSelectionView: UIAlertController?
    var receivedStrings: [String] = []
    var selectedManager: SelectedManager?
    var myCentralManager = CentralManager()
    var myPeripheralManager = PeripheralManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        UNUserNotificationCenter.current().requestAuthorization(options: .alert, completionHandler: {didAllow, error in
        })

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        managerSelectionView = UIAlertController.init(title: "BLUETOOH TYPE SELECTION", message: "\n Please Select Your Device to be a either a Peripheral or Central", preferredStyle: .actionSheet)
        let peripheralAction = UIAlertAction.init(title: "PERIPHERAL", style: .default) { (action) in
            self.selectedManager = SelectedManager.Peripheral
            self.managerLabel.text = SelectedManager.Peripheral.rawValue
            self.startButton.setTitle(StartStopButtons.PeripheralStart.rawValue, for: .normal)
            self.stopButton.setTitle(StartStopButtons.PeripheralStop.rawValue, for: .normal)
        }
        let centralAction = UIAlertAction.init(title: "CENTRAL", style: .default) { (action) in
            self.selectedManager = SelectedManager.Central
            self.managerLabel.text = SelectedManager.Central.rawValue
            self.startButton.setTitle(StartStopButtons.CentralStart.rawValue, for: .normal)
            self.stopButton.setTitle(StartStopButtons.CentralStop.rawValue, for: .normal)
        }
        managerSelectionView?.addAction(centralAction)
        managerSelectionView?.addAction(peripheralAction)
        self.present(managerSelectionView!, animated: true, completion: nil)
    }
    @IBAction func didTapStartButton(_ sender: Any) {
        if let manager = selectedManager{
            switch manager{
            case .Central:
                myCentralManager.didTapStartButton()
                self.startButton.setTitle(StartStopButtons.CentralStart.rawValue, for: .normal)
            case .Peripheral:
                myPeripheralManager.didTapStartButton()
            }
        }
    }
    
    @IBAction func didTapStopButton(_ sender: Any) {
        if let manager = selectedManager{
            switch manager{
            case .Central:
                myCentralManager.didTapStopButton()
            case .Peripheral:
                myPeripheralManager.didTapStopButton()
            }
        }
    }
    //MARK: - TableView Delegates methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedStrings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = receivedStrings[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let manager = selectedManager{
            switch manager{
            case .Central:
                myCentralManager.sendDataToPeripheral()
            case .Peripheral:
                myPeripheralManager.sendDateToCentral()
            }
        }
    }
    
    //MARK: - Peripheral and Central Delegates
    
    func didReceive(stringFromPeripheral: String) {
        receivedStrings.append(stringFromPeripheral)
        tableView.reloadData()
    }
    
    func peripheralBluetoothStatus(status: CBManagerState) {
        changeBluetoothStatus(status: status)
    }
    
    func didReceive(stringFromCentral: String) {
        receivedStrings.append(stringFromCentral)
        tableView.reloadData()
    }
    
    func centralBluetoothStatus(status: CBManagerState) {
        changeBluetoothStatus(status: status)
    }
    
    //MARK:- Private Methods
    
    private func changeBluetoothStatus(status: CBManagerState){
        if status == .poweredOn{
            bluetoothPowerStatus.setOn(true, animated: true)
        }else{
            bluetoothPowerStatus.setOn(false, animated: true)
        }
    }

}

