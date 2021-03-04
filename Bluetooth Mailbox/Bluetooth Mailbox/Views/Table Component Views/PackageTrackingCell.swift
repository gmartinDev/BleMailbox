//
//  PackageTrackingCell.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/1/21.
//

import Foundation
import UIKit

class PackageTrackingCell: UITableViewCell {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    init(reuseId: String) {
        super.init(style: .default, reuseIdentifier: reuseId)
        
        addLabelsToStackView()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        print("Storyboard is not supported, do not use this initializer")
        return nil
    }
    
    private func addLabelsToStackView() {
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(addressLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func createConstraints() {
        createLabelStackConstraints()
    }
    
    private func createLabelStackConstraints() {
        labelStackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(7)
            make.left.right.equalToSuperview().inset(15)
        }
    }
    
    public func setupCell(package: PackageTrackingModel) {
        dateLabel.text = package.date
        addressLabel.text = package.address
        descriptionLabel.text = package.description
    }
}
