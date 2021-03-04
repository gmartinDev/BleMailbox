//
//  PackageTracking.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/1/21.
//

import Foundation

struct PackageTrackingModel: Codable {
    public let date: String
    public let address: String
    public let description: String
    public let latitude: Double
    public let longitude: Double
}
