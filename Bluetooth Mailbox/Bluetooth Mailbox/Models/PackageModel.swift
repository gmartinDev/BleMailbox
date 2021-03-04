//
//  PackageModel.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/1/21.
//

import Foundation

struct PackageModel: Codable {
    public let name: String
    public let description: String
    public let deliveryETA: String?
    public let trackingId: String
}
