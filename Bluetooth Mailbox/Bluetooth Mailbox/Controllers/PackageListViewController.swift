//
//  PackageListViewController.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/1/21.
//

import Foundation
import UIKit

class PackageListViewController: UIViewController {
    private let packageListView: PackageListView
    private var packages: [PackageModel] = []
    private let mailboxBleService: MailboxBluetoothService
    
    init(mailboxService: MailboxBluetoothService) {
        packageListView = PackageListView()
        mailboxBleService = mailboxService
        super.init(nibName: nil, bundle: nil)
        
        mailboxBleService.delegate = self
    }
    
    required init?(coder: NSCoder) {
        print("Do not use this init method, storyboards are not used")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packageListView.delegate = self
        packageListView.datasource = self
        view = packageListView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Call service from AWS to retrieve packages
        
        
        packageListView.refresh()
    }
}

extension PackageListViewController: PackageListViewDelegate {
    func didSelectPackage(at row: Int) {
        //TODO: Open delivery detail view
        let package = getPackageForRow(at: row)
        
        let vc = PackageDetailController(package: package)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapLock() {
        mailboxBleService.sendCommand(type: .lock)
    }
    
    func didTapUnlock() {
        mailboxBleService.sendCommand(type: .unlock)
    }
}

extension PackageListViewController: PackageListViewDatasource {
    func getPackageCount() -> Int {
        packages.count
    }
    
    func getPackageForRow(at row: Int) -> PackageModel {
        packages[row]
    }
}

extension PackageListViewController: MailboxBluetoothServiceDelegate {
    func mailboxDisconnected() {
        packageListView.setMailboxButtons(enabled: false)
    }
    
    func mailboxConencted() {
        packageListView.setMailboxButtons(enabled: true)
    }
}
