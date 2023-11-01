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
    private lazy var datePickerButton = UIDatePicker()
    //private lazy var dateFormatter = DateFormatter()
    private lazy var searchBar = UISearchBar()
    
    
    private let blankPageImagePlaceholder = UIImage(named: "Blank_page_image_placeholder")
    private let trackersTitleLabel = UILabel()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYY"
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        viewControllerSettings()
    }
}

private extension TrackersViewController {
    
    func viewControllerSettings() {
        setupAddTrackerButton()
        setupDatePicker()
        //setupDF()
        
        setupTrackersTitleLabel()
        setupSearchBar()
        
        setupBlankImageView()
        setupBlankPageLabel()
    }
    
    func setupAddTrackerButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Plus")?.withTintColor(.ypBlack, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didAddTrackerButtonTapped)
        )
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePickerButton)
        
        return datePicker
    }
    
    //    func setupDF() -> DateFormatter {
    //        let formatter = dateFormatter
    //        formatter.locale = Locale(identifier: "ru_RU")
    //        formatter.dateFormat = "d MMM YYY"
    //        return formatter
    //    }
    
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
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
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
    
    @objc
    private func didAddTrackerButtonTapped() {
        
    }
    
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        presentedViewController?.dismiss(animated: false)
    }
}
