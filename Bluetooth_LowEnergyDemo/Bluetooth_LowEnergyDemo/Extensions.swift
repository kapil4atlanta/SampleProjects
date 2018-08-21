//
//  Extensions.swift
//  Bluetooth_LowEnergyDemo
//
//  Created by Kapil Rathan on 5/1/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation
import CoreBluetooth

extension UserDefaults {
    
    private static let UUID_KEY = "UUID_KEY"
    private static let PERIPHERAL_KEY = "PERIPHERAL_KEY"
    private static let PERIPHERAL_NAME = "PERIPHERAL_NAME"
    
    var uuid: String? {
        get {
            return value(forKey: UserDefaults.UUID_KEY) as? String
            
        }
        set {
            set(newValue?.description, forKey: UserDefaults.UUID_KEY)
        }
    }
    
    var peripheral: CBPeripheral? {
        get {
            return value(forKey: UserDefaults.PERIPHERAL_KEY) as? CBPeripheral
        }
        set {
            set(newValue, forKey: UserDefaults.PERIPHERAL_KEY)
        }
    }
    
    var peripheralUUID: String? {
        get {
            return value(forKey: UserDefaults.PERIPHERAL_KEY) as? String
        }
        set {
            set(newValue, forKey: UserDefaults.PERIPHERAL_KEY)
        }
    }
    var peripheralName: String? {
        get {
            return value(forKey: UserDefaults.PERIPHERAL_NAME) as? String
        }
        set {
            set(newValue, forKey: UserDefaults.PERIPHERAL_NAME)
        }
    }
}


extension UUID {
    init(nonCryptHash str: String) {
        func hashString(_ str: String) -> String {
            var result = UInt64 (5381)
            
            let buf = [UInt8](str.utf8)
            for b in buf {
                result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
            }
            return String(result)
        }
        
        let str = hashString(str)
        var byteArray: [UInt8] = Array(str.utf8)
        byteArray.reserveCapacity(36)
        
        self = NSUUID(uuidBytes: byteArray) as UUID
    }
}

