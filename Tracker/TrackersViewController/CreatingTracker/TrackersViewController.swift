//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Almira Khafizova on 27.10.23.
//

import UIKit

final class TrackersViewController: UIViewController, UITextFieldDelegate {
    private var trackers: [Tracker] = []
    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private let dataManager = TrackersStorage.shared
    
    private var selectedDate: Int?
    private var filterText: String?
    
    private let collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let params = TrackerGeometricParams(
        cellCount: 2,
        topDistance: 9,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9
    )
    
    private let titleHeader: UILabel = {
        let label = UILabel ()
        label.text = "Трекеры"
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.backgroundColor = .ypBackground
        searchField.textColor = .ypBlackDay
        searchField.font = .systemFont(ofSize: 17, weight: .medium)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.layer.cornerRadius = 10
        searchField.placeholder = "Поиск"
        return searchField
    }()
    
    private lazy var datePickerButton: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        datePicker.backgroundColor = .white
        datePicker.tintColor = .ypBlue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
        return datePicker
    }()
    
    private lazy var blankPageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Blank_page_image_placeholder")
        return imageView
    }()
    
    private lazy var blankPageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        return label
    }()
    
    private let trackersNotFoundImage: UIImageView = {
        let imageView = UIImageView()
        imageView .translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Not_found_image_placeholder")
        return imageView
    }()
    
    private let trackerNotFoundText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ничего не найдено"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let addTrackerButton = UIButton(type: .system)
        addTrackerButton.setImage(UIImage(named: "Plus"), for: .normal)
        addTrackerButton.tintColor = .ypBlackDay
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackerButton.addTarget(self, action: #selector (didAddTrackerButtonTapped), for: .touchUpInside)
        return addTrackerButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        configureView()
        setupNav()
        addElements()
        showFirstPlaceholderScreen()
        configureCollectionView()
        setupConstraints()
    }
    
    private func reloadData() {
        categories = dataManager.categories
        reloadFilteredCategories(text: searchTextField.text, date: datePickerButton.date)
    }
    
    private func configureView() {
        view.backgroundColor = .ypWhiteDay
        searchTextField.returnKeyType = .done
    }
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePickerButton)
    }
    
    private func addElements() {
        view.addSubview(titleHeader)
        view.addSubview(plusButton)
        view.addSubview(searchTextField)
        view.addSubview(datePickerButton)
        
        view.addSubview(blankPageImage)
        view.addSubview(blankPageLabel)
        view.addSubview(trackersNotFoundImage)
        view.addSubview(trackerNotFoundText)
        view.addSubview(collectionView)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.register(
            TrackerTitleSectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerTitleSectionView.id
        )
        collectionView.backgroundColor = .clear
        searchTextField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            blankPageImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blankPageImage.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 220),
            blankPageImage.heightAnchor.constraint(equalToConstant: 80),
            blankPageImage.widthAnchor.constraint(equalToConstant: 80),
            blankPageLabel.centerXAnchor.constraint(equalTo: blankPageImage.centerXAnchor),
            blankPageLabel.topAnchor.constraint(equalTo: blankPageImage.bottomAnchor, constant: 8),
            trackersNotFoundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackersNotFoundImage.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 220),
            trackersNotFoundImage.heightAnchor.constraint(equalToConstant: 80),
            trackersNotFoundImage.widthAnchor.constraint(equalToConstant: 80),
            trackerNotFoundText.centerXAnchor.constraint(equalTo: trackersNotFoundImage.centerXAnchor),
            trackerNotFoundText.topAnchor.constraint(equalTo: trackersNotFoundImage.bottomAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func didAddTrackerButtonTapped() {
        let createNewTrackerVC = NewTrackerViewController()
        createNewTrackerVC.trackersViewController = self
        present(createNewTrackerVC, animated: true, completion: nil)
    }
    
    @objc private func didChangeDate() {
        reloadFilteredCategories(text: searchTextField.text, date: datePickerButton.date)
    }
    
    private func reloadFilteredCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: date)
        self.selectedDate = filterWeekday
        
        filteredCategories = categories.compactMap { category in
            TrackerCategory(title: category.title, trackers: category.trackers.filter { tracker in
                let dateCondition = tracker.schedule?.contains { day in
                    guard let currentDay = self.selectedDate else {
                        return true
                    }
                    return day.rawValue == currentDay
                } ?? false
                let textCondition = tracker.name.contains(self.filterText ?? "") || (self.filterText ?? "").isEmpty
                return textCondition && dateCondition
            })
        }
        .filter { category in
            !category.trackers.isEmpty
        }
        
        collectionView.reloadData()
        showFirstPlaceholderScreen()
        showSecondPlaceholderScreen()
    }
}

extension TrackersViewController: UITextViewDelegate {
    func textFieldShouldReturn(_textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        
        reloadFilteredCategories(text: searchTextField.text, date: datePickerButton.date)
        
        return true
    }
}

// MARK: - TrackersActions
extension TrackersViewController: TrackersActions {
    func appendTracker(tracker: Tracker) {
        self.trackers.append(tracker)
        self.categories = self.categories.map { category in
            var updatedTrackers = category.trackers
            updatedTrackers.append(tracker)
            return TrackerCategory(title: category.title, trackers: updatedTrackers)
        }
        reloadFilteredCategories(text: searchTextField.text, date: datePickerButton.date)
    }
    
    func reload() {
        self.collectionView.reloadData()
    }
    
    func showFirstPlaceholderScreen() {
        if filteredCategories.isEmpty {
            collectionView.isHidden = true
            trackersNotFoundImage.isHidden = true
            trackerNotFoundText.isHidden = true
        } else {
            collectionView.isHidden = false
            trackersNotFoundImage.isHidden = true
            trackerNotFoundText.isHidden = true
            blankPageImage.isHidden = true
            blankPageLabel.isHidden = true
        }
    }
    
    func showSecondPlaceholderScreen() {
        if categories.isEmpty {
            collectionView.isHidden = true
            blankPageImage.isHidden = true
            blankPageLabel.isHidden = true
            trackersNotFoundImage.isHidden = false
            trackerNotFoundText.isHidden = false
        } else {
            collectionView.isHidden = false
            blankPageImage.isHidden = false
            blankPageLabel.isHidden = false
            trackersNotFoundImage.isHidden = true
            trackerNotFoundText.isHidden = true
        }
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = filteredCategories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        let cellData = filteredCategories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
        cell.prepareForReuse()
        cell.delegate = self
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.trackerId == tracker.id
        }.count
        
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: TrackerTitleSectionView.id, for: indexPath) as? TrackerTitleSectionView else {
            return UICollectionReusableView()
        }
        guard indexPath.section < filteredCategories.count else {
            return view
        }
        let titleCategory = filteredCategories[indexPath.section].title
        view.headerText = titleCategory
        
        return view
    }
    
    private func isTrackerCompletedToday (id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date,
                                                inSameDayAs: datePickerButton.date)
        return trackerRecord.trackerId == id && isSameDay
    }
}


extension TrackersViewController: TrackerCellDelegate {
    func completeTracker (id: UUID, at indexPath: IndexPath) {
        let currentDate = Date()
        let selectedDate = datePickerButton.date
        let calendar = Calendar.current
        if calendar.compare(selectedDate, to: currentDate, toGranularity: .day) != .orderedDescending {
            let trackerRecord = TrackerRecord(trackerId: id, date: selectedDate)
            completedTrackers.append(trackerRecord)
            
            collectionView.reloadItems(at: [indexPath])
        } else {
            return
        }
    }
    func incompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: params.leftInset, bottom: 0, right:
                        params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        params.leftInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 47)
        return size
    }
}
