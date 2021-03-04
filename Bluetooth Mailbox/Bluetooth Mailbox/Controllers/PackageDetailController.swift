//
//  PackageDetailController.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/1/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class PackageDetailController: UIViewController {
    private let packageDetailView: PackageDetailView
    private let selectedPackage: PackageModel
    private var packageTracking: [PackageTrackingModel] = []
    
    init(package: PackageModel) {
        packageDetailView = PackageDetailView()
        selectedPackage = package
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        print("Do not use this init method, storyboards are not used")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packageDetailView.datasource = self
        view = packageDetailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Call service from AWS to retrieve tracking details
        
        var pins = [MKPointAnnotation]()
        for trackingDetails in packageTracking {
            let annotation = MKPointAnnotation()
            let coord = CLLocationCoordinate2D(latitude: trackingDetails.latitude, longitude: trackingDetails.longitude)
            annotation.coordinate = coord
            pins.append(annotation)
        }
        
        packageDetailView.refresh(mapPins: pins)
    }
}

extension PackageDetailController: PackageDetailViewDatasource {
    func getTrackingCount() -> Int {
        packageTracking.count
    }
    
    func getTrackingForRow(at row: Int) -> PackageTrackingModel {
        packageTracking[row]
    }
    
    func getSelectedPackage() -> PackageModel {
        selectedPackage
    }
}
