//
//  TrackerCell.swift
//  Tracker
//
//  Created by Almira Khafizova on 07.11.23.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    
    func didTrackerCellTapped(item: TrackerCell.Item, cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {
    struct Item {
        let trackerId: UInt
        let title: String
        let emoji: String
        let color: UIColor
        var count: Int
        var isCompleted: Bool
    }
    
    private static let addButtonSize = 34.0
    private static let emojiViewSize = 24.0
    
    private lazy var addImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var addView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didAddButtonTapped)))
        view.layer.cornerRadius = TrackerCell.addButtonSize * 0.5
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .ypRed
        label.layer.cornerRadius = TrackerCell.emojiViewSize * 0.5
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .ypWhite
        return label
    }()
    
    private weak var delegate: TrackerCellDelegate? = nil
    private var item: TrackerCell.Item? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 90.0),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.widthAnchor.constraint(equalToConstant: TrackerCell.emojiViewSize),
            emojiLabel.heightAnchor.constraint(equalToConstant: TrackerCell.emojiViewSize),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
        ])
        
        addView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addView)
        NSLayoutConstraint.activate([
            addView.widthAnchor.constraint(equalToConstant: TrackerCell.addButtonSize),
            addView.heightAnchor.constraint(equalToConstant: TrackerCell.addButtonSize),
            addView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            addView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
        ])
        
        addImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addImageView)
        NSLayoutConstraint.activate([
            addImageView.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
            addImageView.centerYAnchor.constraint(equalTo: addView.centerYAnchor)
        ])
        
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(daysLabel)
        NSLayoutConstraint.activate([
            daysLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            daysLabel.centerYAnchor.constraint(equalTo: addView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    func setDelegate(delegate: TrackerCellDelegate?) {
        self.delegate = delegate
    }
    
    func bind(item: Item) {
        self.item = item
        cardView.backgroundColor = item.color
        addView.backgroundColor = item.color
        let image = item.isCompleted ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        addImageView.image = image?.withTintColor(.ypWhite, renderingMode: .alwaysOriginal)
        daysLabel.text = getDaysString(days: item.count)
        emojiLabel.text = item.emoji
        titleLabel.text = item.title
    }
    
    private func getDaysString(days: Int) -> String {
        switch days {
        case 1:
            return "\(days) день"
        case 2, 3, 4:
            return "\(days) дня"
        default:
            return "\(days) дней"
        }
    }
    
    @objc
    private func didAddButtonTapped() {
        guard let item = item else { return }
        delegate?.didTrackerCellTapped(item: item, cell: self)
    }
}

