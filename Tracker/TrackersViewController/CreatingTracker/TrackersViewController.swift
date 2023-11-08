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
    
    private var cellItems: [[TrackerCell.Item]] = [[]]
    private var currentDate = Date()
    
    private var trackersStorage: TrackersStorageProtocol = {
        return ServiceLocator.instance.trackerStorage
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(TrackerCell.self)
        collectionView.register(TrackerTitleSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerTitleSectionView.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var datePickerButton: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        datePicker.backgroundColor = .white
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([
        datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
        return datePicker
    }()
    
    private lazy var blankPageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Blank_page_image_placeholder")
        return imageView
    }()
    
    private lazy var blankPageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.addTarget(self, action: #selector(didSearchChanged), for: .editingChanged)
        searchField.backgroundColor = .ypBackground
        searchField.delegate = self
        searchField.placeholder = "Поиск"
        return searchField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Plus")?.withTintColor(.ypBlack, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didAddTrackerButtonTapped)
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePickerButton)
        
        let trackersTitleLabel = UILabel()
        trackersTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackersTitleLabel.text = "Трекеры"
        trackersTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersTitleLabel)
        NSLayoutConstraint.activate([
            trackersTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.topAnchor.constraint(equalTo: trackersTitleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        blankPageImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blankPageImage)
        NSLayoutConstraint.activate([
            blankPageImage.heightAnchor.constraint(equalToConstant: 80),
            blankPageImage.widthAnchor.constraint(equalToConstant: 80),
            blankPageImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            blankPageImage.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        
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
        let newTrackerViewController = NewTrackerViewController(delegate: self)
        present(newTrackerViewController, animated: true, completion: nil) //self?
    }
    
    @objc private func didChangeDate(sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate =  dateFormatter.string(from: selectedDate)
    }
    
    @objc
    private func didSearchChanged(sender: UISearchTextField) {
        
    }
    
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellItems[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithType(TrackerCell.self, for: indexPath)
        cell.setDelegate(delegate: self)
        let cellItem = cellItems[indexPath.section][indexPath.row]
        cell.bind(item: cellItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerTitleSectionView.reuseIdentifier, for: indexPath) as? TrackerTitleSectionView
        //view?.bind(item: categories[indexPath.section].title)
        return view ?? UICollectionReusableView()
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    static let interitemSpace = 8.0
    static let sideInsetSpace = 16.0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - TrackersViewController.sideInsetSpace * 2 - TrackersViewController.interitemSpace) / 2
        return CGSize(width: width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12.0, left: TrackersViewController.sideInsetSpace, bottom: 16.0, right: TrackersViewController.sideInsetSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return TrackersViewController.interitemSpace
    }
}

extension TrackersViewController: NewTrackerViewControllerDelegate {
    
    func didTrackerAdded(category: String, tracker: Tracker) {
        
    }
}

extension TrackersViewController: TrackerCellDelegate {
    
    func didTrackerCellTapped(item: TrackerCell.Item, cell: TrackerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let currentDate = Date()
        if currentDate < currentDate {
            return
        }
        
        var cellItem = cellItems[indexPath.section][indexPath.row]
        if cellItem.isCompleted {
            if let index = completedTrackers.firstIndex(where: { record in
                record.trackerId == item.trackerId && record.date == currentDate.timeIntervalSince1970
            }) {
                completedTrackers.remove(at: index)
            }
            cellItem.count = item.count - 1
        } else {
            let trackerRecord = TrackerRecord(trackerId: item.trackerId, date: currentDate.timeIntervalSince1970)
            completedTrackers.append(trackerRecord)
            cellItem.count = item.count + 1
        }
        
        cellItem.isCompleted = !cellItem.isCompleted
        cellItems[indexPath.section][indexPath.row] = cellItem
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

