//
//  PackageDetailHeaderView.swift
//  Bluetooth Mailbox
//
//  Created by Greg Martin on 3/1/21.
//

import Foundation
import UIKit

class PackageDetailHeaderView: UIView {
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    private let trackingIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemGray2
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addHeaderViews()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        print("Storyboard is not supported, do not use this initializer")
        return nil
    }
    
    private func addHeaderViews() {
        addSubview(headerTitle)
        addSubview(trackingIdLabel)
    }
    
    private func createConstraints() {
        headerTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        trackingIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerTitle.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    public func setHeaderLabels(title: String, trackingId: String) {
        headerTitle.text = title
        trackingIdLabel.text = trackingId
    }
}
