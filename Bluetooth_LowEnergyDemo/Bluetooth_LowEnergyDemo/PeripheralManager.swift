//
//  PeripheralManager.swift
//  Bluetooth_LowEnergyDemo
//
//  Created by Kapil Rathan on 5/1/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import AdSupport

public protocol PeripheralDelegate: class {
    func didReceive(stringFromCentral: String)
    func peripheralBluetoothStatus(status: CBManagerState)
}

class PeripheralManager: NSObject, CBPeripheralManagerDelegate, CBPeripheralDelegate {
    static let shared = PeripheralManager()
    weak var delegate: PeripheralDelegate?
    var myPeripheralManager: CBPeripheralManager?
    var discoveredPeripheral: CBPeripheral?
    var data: Data?
    var myCharacteristic: CBMutableCharacteristic?
    var myUniqueCharacteristic: CBMutableCharacteristic?
    var mydiscoveredCentrals : [String] = []
    let singleton = Singleton.sharedInstance()
    
    override init() {
        super.init()
        myPeripheralManager = CBPeripheralManager.init(delegate: self, queue: nil, options: [CBPeripheralManagerOptionRestoreIdentifierKey: "kapiliPadPeripheral", CBPeripheralManagerRestoredStateServicesKey: CBUUID.init(string: TRANSFER_SERVICE_UUID), CBPeripheralManagerRestoredStateAdvertisementDataKey: "$KAPIL$" ])
    }

    //MARK: - Public Methods
    
    func didTapStopButton(){
        stopAdvertising()
    }
    func didTapStartButton(){
        startAdvertising()
    }
    
    func startAdvertising(){
        let myCustomServiceUUID = CBUUID.init(string: TRANSFER_SERVICE_UUID)
        var uuids = [CBUUID]()
        uuids.append(myCustomServiceUUID)
        let adData: [String : Any] = [CBAdvertisementDataServiceUUIDsKey : uuids, CBAdvertisementDataLocalNameKey : "$KAPIL$"]
        print("key string: \(CBAdvertisementDataLocalNameKey)")
        myPeripheralManager?.startAdvertising(adData)
    }
    
    func stopAdvertising(){
        myPeripheralManager?.stopAdvertising()
    }
    
    func sendDateToCentral(){
        if let data = "WAKEUP".data(using: .utf8), let chars = self.myUniqueCharacteristic, let _ = self.myPeripheralManager?.updateValue(data, for: chars, onSubscribedCentrals: nil){
            print("did Send data to WAKEUP")
        }
    }
    
    //MARK: - PeripheralManager Delegate Methods
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        singleton.scheduleNotification(title: "Did Wake up from Dead",  message: "Hey I am still here", inSeconds: 5)
        if let peripheralsServices = dict[CBPeripheralManagerRestoredStateServicesKey] {
            if let advertising = myPeripheralManager?.isAdvertising, advertising == false {
                let ads = dict[CBPeripheralManagerRestoredStateAdvertisementDataKey]
                self.startAdvertising()
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Central Subscribed")
        
        singleton.scheduleNotification(title: "Central Subscribed",  message: central.identifier.uuidString, inSeconds: 2)
        
        if let data = "EOM".data(using: .utf8), let chars = self.myUniqueCharacteristic, let _ = self.myPeripheralManager?.updateValue(data, for: chars, onSubscribedCentrals: nil){
            print("did Send data")
        }
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("did unsusbcribed")
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            let myCustomServiceUUID = CBUUID.init(string: TRANSFER_CHARACTERISTIC_UUID)
            self.myCharacteristic = CBMutableCharacteristic.init(type: myCustomServiceUUID, properties: .write, value: nil, permissions: .writeable)
            let adID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            self.myUniqueCharacteristic = CBMutableCharacteristic.init(type: CBUUID.init(string: adID), properties: .notify, value: nil, permissions: .writeable)
            
            let myService = CBMutableService.init(type: CBUUID.init(string: TRANSFER_SERVICE_UUID), primary: true)
            var charectericts = [CBMutableCharacteristic]()
            charectericts.append(self.myCharacteristic!)
            charectericts.append(self.myUniqueCharacteristic!)
            myService.characteristics = charectericts
            self.myPeripheralManager?.add(myService)
            
            print("powered ON")
        case .poweredOff:
            print("powered OFF")
        case .unsupported:
            print("unsupported")
        default:
            break
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?){
        if peripheral.isAdvertising{
            print("My Device Started Advertising")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error == nil{
            print("success publishing the service")
            if singleton.appRestored == true && !singleton.peripheralManagerToRestore.isEmpty{
                startAdvertising()
            }
        }else{
            print(error?.localizedDescription)
        }
        
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        print("the State of Peripheral is %d", peripheral.state.rawValue)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests{
            if let data = request.value, let receivedString = String(data: data, encoding: .utf8){
                self.delegate?.didReceive(stringFromCentral: receivedString)
                print(receivedString)
                mydiscoveredCentrals.append(receivedString)
                singleton.scheduleNotification(title: "Did Receive Write Request from Cenral",  message: receivedString, inSeconds: 5)
            }
        }
    }
    
    //MARK:- Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mydiscoveredCentrals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let central = mydiscoveredCentrals[indexPath.row]
        cell?.textLabel?.text = central
        return cell!
    }
}

