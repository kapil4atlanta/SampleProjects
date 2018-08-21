//
//  CentralManager.swift
//  Bluetooth_LowEnergyDemo
//
//  Created by Kapil Rathan on 5/1/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.

import UIKit
import CoreBluetooth
import UserNotifications

public protocol CentralDelegate: class{
    func didReceive(stringFromPeripheral: String)
    func centralBluetoothStatus(status: CBManagerState)
}

class CentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let shared = CentralManager()
    public weak var delegate: CentralDelegate?
    var centralManager = (UIApplication.shared.delegate as? AppDelegate)?.centralManager
    var peripheralsArray = [CBPeripheral]()
    let userDefaults = UserDefaults()
    
    var discoveredPeripheral: CBPeripheral?
    var discoveredPeripheralName: String?
    var discoveredPeripheralCharacteristics: CBCharacteristic?
    
    var data: NSMutableData?
    
    var transferServiceUUID_FromPeripheral: CBUUID?
    var characteristicUUID_FromPeripheral: CBUUID?
    
    override init() {
        super.init()
         centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    

    //MARK:- Public Methods
    
    func didTapStopButton(){
        stopScanningPeripherals()
    }
    func didTapStartButton(){
        startScanningForPeripherals()
    }
    
    func startScanningForPeripherals(){
        if centralManager?.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: nil)
            print("STARTED SCANNING")
        }
    }
    
    func stopScanningPeripherals(){
        print("STOPPING")
        peripheralsArray = []
        self.cleanup()
    }

    func sendDataToPeripheral(){
        if let discoverdPeripheral = discoveredPeripheral, let chars = discoveredPeripheralCharacteristics, discoverdPeripheral.state != .disconnected {
            let tempString = "WAKEUP From Central: " + String(describing: discoverdPeripheral.identifier)
            let data = tempString.data(using: .utf8)!
            if centralManager?.state == .poweredOn {
                discoverdPeripheral.writeValue(data, for: chars, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    //MARK:- Central Manager Delegates
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            print("central.state is .unknown")
            self.delegate?.centralBluetoothStatus(status: .unknown)
        case .resetting:
            print("central.state is .ressetting")
            self.delegate?.centralBluetoothStatus(status: .resetting)
        case .unsupported:
            print("central.state is .unsupported")
            self.delegate?.centralBluetoothStatus(status: .unsupported)
        case .unauthorized:
            print("central.state is .unauthorized")
            self.delegate?.centralBluetoothStatus(status: .unauthorized)
        case .poweredOff:
            print("central.state is .poweredOff")
            self.delegate?.centralBluetoothStatus(status: .poweredOff)
        case .poweredOn:
            print("central.state is .poweredOn")
            self.delegate?.centralBluetoothStatus(status: .poweredOn)
            centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false, CBConnectPeripheralOptionNotifyOnConnectionKey: true])
            
            if let services = discoveredPeripheral?.services, let serviceUUID = transferServiceUUID_FromPeripheral{
                for service in services{
                    if service.uuid == transferServiceUUID_FromPeripheral{
                        discoveredPeripheral?.discoverServices([serviceUUID])
                    }
                }
            }
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("SCANNING")
         if let serviceUUIDs = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID], let serviceID = serviceUUIDs.first, serviceID == CBUUID.init(string: TRANSFER_SERVICE_UUID){
            discoveredPeripheralName = peripheral.name
            peripheralsArray.append(peripheral)
            userDefaults.peripheralUUID = peripheral.identifier.uuidString
            userDefaults.peripheralName = peripheral.name
            
            print("peripheral: \(peripheral)")
            print("uuid: \(peripheral.identifier)")
            print("peripheral name: \(peripheral.name ?? "NO NAMEEE")")
            print("advertisementData: \(advertisementData)")
            print("rssi: \(RSSI)")
            print("-----------------------------------------------")
            
            
            if let serviceUUID = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID]{
                print("service UUID: \(serviceUUID.first)")
                transferServiceUUID_FromPeripheral = serviceUUID.first
            }
            
            centralManager?.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnNotificationKey : 1, CBConnectPeripheralOptionNotifyOnConnectionKey: 1])
            
            centralManager?.stopScan()
        } else{
            if let persistedPeripheral = self.userDefaults.peripheralUUID, peripheral.identifier.uuidString == persistedPeripheral, let name = self.userDefaults.peripheralName{
                //check persisted peripherals
                discoveredPeripheral = peripheral
                discoveredPeripheralName = name
                
                if let serviceUUIDs = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID], let serviceID = serviceUUIDs.first, serviceID == CBUUID.init(string: TRANSFER_SERVICE_UUID){
                    transferServiceUUID_FromPeripheral = serviceID
                }
                
                centralManager?.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnNotificationKey : 1, CBConnectPeripheralOptionNotifyOnConnectionKey: 1])
                peripheralsArray.append(peripheral)
                centralManager?.stopScan()
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Kapil_iPhone didConnect")
        print("state: \(peripheral.state.rawValue)")
        //5E323EEE-5939-4BE5-8986-B53F37226A1D
        
        peripheral.delegate = self
        if let transferServiceUUID = transferServiceUUID_FromPeripheral {
            peripheral.discoverServices([transferServiceUUID])
            discoveredPeripheral = peripheral
        } else {
            print("ERROR: DIDNT GET TRANSFER SERVICE UUID FROM PERIPHERAL")
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("DID FAIL TO CONNECT: \(error.localizedDescription)")
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Kapil_iPhone didDiscoverServices")
        if let error = error {
            print("ERROR 1: \(error.localizedDescription)")
            return
        }
        
        if let peripheralServices = peripheral.services {
            print("peripheralServices: \(peripheralServices)")
            for service in peripheralServices {
                print("service: \(service)")
                peripheral.discoverCharacteristics([], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Kapil_iPhone didDiscoverCharacteristicsFor: \(service)")
        
        if let error = error {
            print("ERROR 2: \(error.localizedDescription)")
            return
        }
        
        
        
        if let serviceCharacteristics = service.characteristics {
            print("Kapil_iPhone characteristics: \(serviceCharacteristics)")
            for characteristic in serviceCharacteristics{
                print("characterstic!")
                if characteristic.uuid.isEqual(CBUUID.init(string: TRANSFER_CHARACTERISTIC_UUID)) {
                    discoveredPeripheralCharacteristics = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("Notifying peripheral")
                    
                    
                    let tempString = "HELLO MARCUS! THIS IS OUR DEMO TEST! From Central: " + String(describing: peripheral.identifier)
                    let data = tempString.data(using: .utf8)!
                    if centralManager?.state == .poweredOn {
                        peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    }
                } else if characteristic.uuid.isEqual(CBUUID.init(string: "42E53B55-E801-430B-A6EC-F7FE5964D04D")) {
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("Notifying peripheral2!!")
                    
                    
                    let tempString = "HELLO MARCUS! THIS IS OUR DEMO TEST! From Central: " + String(describing: peripheral.identifier)
                    let data = tempString.data(using: .utf8)!
                    //          if centralManager.state == .poweredOn {
                    //            peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    //          }
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("Central Did Write Value to Peripheral")
        
        if let error = error {
            print("OUCHHH ERROR: \(error.localizedDescription)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpadValueFor")
        if let error = error {
            print("ERROR 3: \(error)")
            return
        }
        
        
        if let data = characteristic.value {
            let stringData = String.init(data: data, encoding: .utf8)
            print("Kapil_iPhone stringData: \(stringData ?? "NO DATA1")")
            
            if stringData == "EOM" {
               self.delegate?.didReceive(stringFromPeripheral: String(describing: characteristic.uuid))
            }
            
        }
        
        if let data = characteristic.value {
            self.data?.append(data)
        }
        
        //    centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func cleanup() {
        
        if centralManager?.state == .poweredOn {
            centralManager?.stopScan()
            transferServiceUUID_FromPeripheral = nil
        }
        
        if let discoveredPeripheral = discoveredPeripheral {
            if discoveredPeripheral.state != .connected {
                return
            }
            
            if let services = discoveredPeripheral.services {
                for service in services {
                    if let characteristics = service.characteristics {
                        for charact in characteristics {
                            if charact.uuid.isEqual([CBUUID.init(string: TRANSFER_CHARACTERISTIC_UUID)]) {
                                if charact.isNotifying {
                                    print("turned off notifying")
                                    self.discoveredPeripheral?.setNotifyValue(false, for: charact)
                                    return
                                }
                            }
                        }
                    }
                    
                }
            }
            print("Cancelling peripheral connection")
            centralManager?.cancelPeripheralConnection(discoveredPeripheral)
        }
    }
    
    
    
}
