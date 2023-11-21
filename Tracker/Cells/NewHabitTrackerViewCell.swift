//
//  NewHabitTrackerViewCell.swift
//  Tracker
//
//  Created by Almira Khafizova on 16.11.23.
//

import UIKit

final class NewHabitTrackerViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chevronImage: UIImageView = {
        let chevronImage = UIImageView()
        chevronImage.image = UIImage(named: "Chevron")
        chevronImage.tintColor = .ypGray
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        return chevronImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypBackgroundDay
        clipsToBounds = true
        
        addSubview(titleLabel)
        addSubview(chevronImage)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImage.widthAnchor.constraint(equalToConstant: 24),
            chevronImage.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    func update(with title: String) {
        titleLabel.text = title
    }
}

