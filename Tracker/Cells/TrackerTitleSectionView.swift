//
//  BlockTitleView.swift
//  Tracker
//
//  Created by Almira Khafizova on 07.11.23.
//

import UIKit

final class TrackerTitleSectionView: UICollectionReusableView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .natural
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func bind(item: String) {
        label.text = item
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
