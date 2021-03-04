//
//  PackageListView.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/1/21.
//

import Foundation
import UIKit

protocol PackageListViewDelegate: class {
    func didSelectPackage(at row: Int)
    func didTapLock()
    func didTapUnlock()
}

protocol PackageListViewDatasource: class {
    func getPackageCount() -> Int
    func getPackageForRow(at row: Int) -> PackageModel
}

class PackageListView: UIView {
    weak var datasource: PackageListViewDatasource?
    weak var delegate: PackageListViewDelegate?
    
    private let packageCellReuseId = "PackageCell"
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.tableFooterView = UIView()
        table.backgroundColor = .systemBackground
        table.layer.borderWidth = 1
        table.layer.borderColor = UIColor.systemGray.cgColor
        return table
    }()
    
    private let lockButton: UIButton = {
        let lock = UIButton(type: .roundedRect)
        lock.backgroundColor = .systemBlue
        lock.setTitle("Lock", for: .normal)
        lock.setTitleColor(.black, for: .normal)
        lock.addTarget(self, action: #selector(lockPressed), for: .touchUpInside)
        lock.isEnabled = false
        return lock
    }()
    
    private let unlockButton: UIButton = {
        let unlock = UIButton(type: .roundedRect)
        unlock.backgroundColor = .systemGray4
        unlock.setTitle("Unlock", for: .normal)
        unlock.setTitleColor(.black, for: .normal)
        unlock.addTarget(self, action: #selector(unlockPressed), for: .touchUpInside)
        unlock.isEnabled = false
        return unlock
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubViews()
        createConstraints()
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        print("Do not use this init method, storyboards are not used")
        return nil
    }
    
    private func addSubViews() {
        addSubview(lockButton)
        addSubview(unlockButton)
        addSubview(tableView)
    }
    
    private func createConstraints() {
        makeLockButtonConstraints()
        makeUnlockButtonConstraints()
        makeTableViewConstraints()
    }
    
    private func makeLockButtonConstraints() {
        lockButton.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(snp.centerX).offset(-5)
            make.height.equalTo(50)
        }
    }
    
    private func makeUnlockButtonConstraints() {
        unlockButton.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview().inset(15)
            make.left.equalTo(snp.centerX).offset(5)
            make.height.equalTo(50)
        }
    }
    
    private func makeTableViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(lockButton.snp.bottom).offset(10)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc private func lockPressed() {
        delegate?.didTapLock()
    }
    
    @objc private func unlockPressed() {
        delegate?.didTapUnlock()
    }
    
    public func setMailboxButtons(enabled: Bool) {
        lockButton.isEnabled = enabled
        unlockButton.isEnabled = enabled
    }
    
    public func refresh() {
        tableView.reloadData()
    }
}

extension PackageListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource?.getPackageCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let package = datasource?.getPackageForRow(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        let cell = PackageListCell(reuseId: packageCellReuseId)
        cell.setupCell(package: package)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Deliveries"
    }
}

extension PackageListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectPackage(at: indexPath.row)
    }
}
