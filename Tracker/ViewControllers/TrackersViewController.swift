//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Almira Khafizova on 27.10.23.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private lazy var blankPageImage = UIImageView()
    private lazy var blankPageLabel = UILabel()
    private let blankPageImagePlaceholder = UIImage(named: "Blank_page_image_placeholder")
    private let trackersTitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupAddTrackerButton()
        setupTrackersTitleLabel()
        setupBlankImageView()
        setupBlankPageLabel()
    }
}

private extension TrackersViewController {
    
    func setupAddTrackerButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Plus")?.withTintColor(.ypBlack, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didAddTrackerButtonTapped)
        )
    }
    
    func setupTrackersTitleLabel() {
        trackersTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackersTitleLabel.text = "Трекеры"
        
        trackersTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersTitleLabel)
        
        NSLayoutConstraint.activate([
            trackersTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupBlankImageView() {
        blankPageImage.image = blankPageImagePlaceholder
        
        blankPageImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blankPageImage)
        
        NSLayoutConstraint.activate([
            blankPageImage.heightAnchor.constraint(equalToConstant: 80),
            blankPageImage.widthAnchor.constraint(equalToConstant: 80),
            blankPageImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            blankPageImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func setupBlankPageLabel() {
        blankPageLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        blankPageLabel.text = "Что будем отслеживать?"
        blankPageLabel.textAlignment = .center
        blankPageLabel.textColor = .ypBlack
        
        blankPageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blankPageLabel)
        
        NSLayoutConstraint.activate([
            blankPageLabel.topAnchor.constraint(equalTo: blankPageImage.bottomAnchor, constant: 8),
            blankPageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            blankPageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    private func didAddTrackerButtonTapped() {
        
    }
}
