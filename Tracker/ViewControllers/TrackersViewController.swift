//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Almira Khafizova on 27.10.23.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private lazy var blankPageImage = UIImageView()
    private lazy var blankPageLabel = UILabel()
    private lazy var datePickerButton = UIDatePicker()
    private lazy var searchBar = UISearchBar()
    private lazy var screensaver = UIStackView()
    
    private let addButton = UIImage(named: "Plus")
    private let addNewTrackerButton = UIButton(type: .system)
    private let blankPageImagePlaceholder = UIImage(named: "Blank_page_image_placeholder")
    private let trackersTitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        self.restorationIdentifier = "TrackerViewController"
        
        viewControllerUISettings()
    }
}

private extension TrackersViewController {
    
    func viewControllerUISettings() {
        setupAddTrackerButton()
        setupDatePicker()
        
        setupTrackersTitleLabel()
        setupSearchBar()
        
        setupBlankImageView()
        setupBlankPageLabel()
        
        setupScreenSaver()
    }
    
    func setupAddTrackerButton() {
        
        addNewTrackerButton .frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        addNewTrackerButton .setImage(addButton, for: .normal)
        addNewTrackerButton .addTarget(self, action: #selector(didAddTrackerButtonTapped), for: .touchUpInside)
        addNewTrackerButton .tintColor = .black
        
        addNewTrackerButton .translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNewTrackerButton)
        
        NSLayoutConstraint.activate([
            addNewTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            addNewTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            
        ])
    }
    
    func setupDatePicker() -> UIDatePicker {
        let datePicker = datePickerButton
        datePicker.backgroundColor = .white
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        return datePicker
    }
    
    func setupTrackersTitleLabel() {
        trackersTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackersTitleLabel.text = "Трекеры"
        
        trackersTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersTitleLabel)
        
        NSLayoutConstraint.activate([
            trackersTitleLabel.topAnchor.constraint(equalTo: addNewTrackerButton.bottomAnchor, constant: 12),
            trackersTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    func setupSearchBar() -> UISearchBar {
        let text = "Поиск"
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = false
        searchBar.placeholder = text
        searchBar.frame = CGRect(x: 0, y: 0, width: 343, height: 36)
        searchBar.backgroundColor = .ypBackground
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: trackersTitleLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        return searchBar
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
    
    func setupScreenSaver() {
        let stack = screensaver
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        stack.addArrangedSubview(blankPageImage)
        stack.addArrangedSubview( blankPageLabel)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)])
    }
    
    @objc
    private func didAddTrackerButtonTapped() {
        let newTrackerViewController = NewTrackerViewController() //(delegate: self)
        self.present(newTrackerViewController, animated: true, completion: nil)
    }
    
    @objc private func didChangeDate(sender: UIDatePicker) { }
}
