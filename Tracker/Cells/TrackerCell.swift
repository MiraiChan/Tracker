//
//  TrackerCell.swift
//  Tracker
//
//  Created by Almira Khafizova on 07.11.23.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func incompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel ()
        label.backgroundColor = .ypBackgroundDay
        label.clipsToBounds = true
        label.layer.cornerRadius = 24 / 2
        label.font = .systemFont(ofSize: 16, weight: .medium)//?14
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhiteDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = 143
        label.frame = CGRect(x: 120, y: 106, width: 143, height: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel ()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.frame = CGRect(x: 120, y: 106, width: 101, height: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = plusImage
        button.tintColor = .ypWhiteDay
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 34 / 2
        button.addTarget(self, action: #selector(didAddButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    weak var delegate: TrackerCellDelegate?
    static var reuseId = "cell"
    
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    //MARK: - Helpers
    
    func configure(
        with tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        addElements()
        setupConstraints()
        self.cardView.backgroundColor = tracker.color
        self.addButton.backgroundColor = tracker.color
        
        taskTitleLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        
        let wordDay = pluralizeDays(completedDays)
        daysLabel.text = "\(wordDay)"
        
        let image = isCompletedToday ?
        doneImage?.withTintColor(cardView.backgroundColor ?? .ypWhiteDay) :
        plusImage.withTintColor(cardView.backgroundColor ?? .ypWhiteDay)
        addButton.setImage(image, for: UIControl.State.normal)
        if isCompletedToday {
            addButton.alpha = 0.4
        } else {
            addButton.alpha = 1
        }
    }

    private let plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(
            systemName: "plus",
            withConfiguration: pointSize
        )?.withRenderingMode(.alwaysTemplate) ?? UIImage ()
        return image
    }()
    
    private let doneImage = UIImage(named: "Done")?.withRenderingMode(.alwaysTemplate)
    
    private func addElements() {
        contentView.addSubview(cardView)
        contentView.addSubview(stackView)
        
        contentView.addSubview(emojiLabel)
        contentView.addSubview(taskTitleLabel)
        
        stackView.addArrangedSubview(daysLabel)
        stackView.addArrangedSubview(addButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            cardView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            cardView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            cardView.heightAnchor.constraint(
                equalToConstant: 90
            ),
            emojiLabel.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 12
            ),
            
            emojiLabel.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: 12
            ),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            taskTitleLabel.leadingAnchor.constraint(
                equalTo: emojiLabel.leadingAnchor
            ),
            
            taskTitleLabel.bottomAnchor.constraint(
                equalTo: cardView.bottomAnchor,
                constant: -12
            ),
            taskTitleLabel.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -12
            ),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 12
            ),
            
            stackView.topAnchor.constraint(
                equalTo: cardView.bottomAnchor,
                constant: 8
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            )
        ])
    }
    
    private func pluralizeDays(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        if remainder10 >= 1 && remainder100 <= 19 {
            return "\(count) дней"
        }
        switch remainder10 {
        case 1:
            return "\(count) день"
        case 2, 3, 4:
            return "\(count) дня"
        default:
            return "\(count) дней"
        }
    }
    
    @objc private func didAddButtonTapped() {
        guard let trackerId = trackerId,
              let indexPath = indexPath else {
            assertionFailure("no trackerId")
            return
        }

        if isCompletedToday {
            delegate?.incompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}
