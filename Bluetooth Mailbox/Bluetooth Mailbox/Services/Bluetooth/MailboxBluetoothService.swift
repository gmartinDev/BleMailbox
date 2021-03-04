//
//  MailboxBluetoothService.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/2/21.
//

import Foundation
import CoreBluetooth

let kMailboxPeripheralId = "MailboxPeripheralId"

protocol MailboxBluetoothServiceDelegate: class {
    func mailboxDisconnected()
    func mailboxConencted()
}

public enum MailboxCommand {
    case lock
    case unlock
}

class MailboxBluetoothService: NSObject {
    private let mailbox: MailboxModel
    private var cbCentralManager: CBCentralManager
    private var peripheral: CBPeripheral?
    
    private var commandType: MailboxCommand?
    
    private var lockCharacteristic: CBCharacteristic?
    private var unlockCharacteristic: CBCharacteristic?
    private var authorizeCharacteristic: CBCharacteristic?
    
    public weak var delegate: MailboxBluetoothServiceDelegate?
    
    init(mailbox mailboxModel: MailboxModel) {
        mailbox = mailboxModel
        cbCentralManager = CBCentralManager()
        super.init()
        cbCentralManager.delegate = self
    }
    
    public func sendCommand(type: MailboxCommand) {
        guard let peripheral = peripheral else {
            print("Mailbox peripheral not set, cannot send command")
            return
        }
        
        commandType = type
        
        if let authData = "Authorize".data(using: .utf8), let char = authorizeCharacteristic {
            peripheral.writeValue(authData, for: char, type: .withResponse)
        }
    }
}

extension MailboxBluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            //If mailbox only had specific services we could specify them here
            cbCentralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // if id is not found or does not match our mailbox keep scanning
        guard let peripheralId = advertisementData[kMailboxPeripheralId] as? String,
              peripheralId == mailbox.uuid else {
            return
        }
        
        self.peripheral = peripheral
        guard let foundPeripheral = self.peripheral else { return }
        foundPeripheral.delegate = self
        self.cbCentralManager.connect(foundPeripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            peripheral.discoverServices([
                MailboxPeripheral.lockMailboxServiceUUID,
                MailboxPeripheral.unlockMailboxServiceUUID
            ])
            delegate?.mailboxConencted()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            delegate?.mailboxDisconnected()
            self.peripheral = nil
            
            //Rescan for mailbox
            cbCentralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
}

extension MailboxBluetoothService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                switch service.uuid {
                case MailboxPeripheral.lockMailboxServiceUUID:
                    peripheral.discoverCharacteristics([MailboxPeripheral.lockMailboxCharacteristicUUID], for: service)
                case MailboxPeripheral.unlockMailboxServiceUUID:
                    peripheral.discoverCharacteristics([MailboxPeripheral.unlockMailboxCharacteristicUUID], for: service)
                default:
                    continue
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                switch characteristic.uuid {
                case MailboxPeripheral.lockMailboxCharacteristicUUID:
                    lockCharacteristic = characteristic
                case MailboxPeripheral.unlockMailboxCharacteristicUUID:
                    unlockCharacteristic = characteristic
                case MailboxPeripheral.authorizeCharacteristricUUID:
                    authorizeCharacteristic = characteristic
                default:
                    continue
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        let char = descriptor.characteristic
        guard char == authorizeCharacteristic else {
            //Currently only get response for authorizing
            return
        }
        
        if error == nil {
            //Message succeeded - user is authroized
            switch commandType {
            case .lock:
                if let lockData = "Lock".data(using: .utf8), let char = lockCharacteristic {
                    peripheral.writeValue(lockData, for: char, type: .withoutResponse)
                }
            case .unlock:
                if let lockData = "Unlock".data(using: .utf8), let char = unlockCharacteristic {
                    peripheral.writeValue(lockData, for: char, type: .withoutResponse)
                }
            default:
                break
            }
        }
        
        commandType = nil
    }
}
