//
//  MailboxPeripheral.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/2/21.
//

import Foundation
import CoreBluetooth

class MailboxPeripheral: NSObject {
    public static let authorizeServiceUUID = CBUUID(string: "1auth")
    public static let authorizeCharacteristricUUID = CBUUID(string: "1e131e28-c22f-4b6c-9b88-e33531ae39dc")
    
    public static let lockMailboxServiceUUID = CBUUID(string: "1lock")
    public static let lockMailboxCharacteristicUUID = CBUUID(string: "1e131e28-c22f-44aa-a232-14a067972f31")
    
    public static let unlockMailboxServiceUUID = CBUUID(string: "1unlock")
    public static let unlockMailboxCharacteristicUUID = CBUUID(string: "49b96d7f-beeb-4b6c-9b88-e33531ae39dc")
}
