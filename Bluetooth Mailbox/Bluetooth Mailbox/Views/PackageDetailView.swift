//
//  PackageDetailView.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/1/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

protocol PackageDetailViewDatasource: class {
    func getTrackingCount() -> Int
    func getTrackingForRow(at row: Int) -> PackageTrackingModel
    func getSelectedPackage() -> PackageModel
}

class PackageDetailView: UIView {
    weak var datasource: PackageDetailViewDatasource?
    
    private let trackingReuseId = "TrackingCell"
    private let mapPinId = "TrackingPin"
    
    private let locationManager = CLLocationManager()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.tableFooterView = UIView()
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        return map
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubViews()
        createConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    required init?(coder: NSCoder) {
        print("Do not use this init method, storyboards are not used")
        return nil
    }
    
    private func addSubViews() {
        addSubview(tableView)
        addSubview(mapView)
    }
    
    private func createConstraints() {
        makeTableViewConstraints()
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
    }
    
    private func makeMapViewConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(mapView.snp.width)
        }
    }
    
    public func refresh(mapPins: [MKPointAnnotation]) {
        tableView.reloadData()
        
        mapView.addAnnotations(mapPins)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}

extension PackageDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let package = datasource?.getSelectedPackage() else {
            print("could not get the selected package")
            return nil
        }
        let headerView = PackageDetailHeaderView()
        headerView.setHeaderLabels(title: package.name, trackingId: package.trackingId)
        return headerView
    }
}

extension PackageDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource?.getTrackingCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let trackingInfo = datasource?.getTrackingForRow(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        let cell = PackageTrackingCell(reuseId: trackingReuseId)
        cell.setupCell(package: trackingInfo)
        return cell
    }
}

extension PackageDetailView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: mapPinId) else {
            let newPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: mapPinId)
            newPinView.canShowCallout = false
            return newPinView
        }
        
        annotationView.annotation = annotation
        return annotationView
    }
}
