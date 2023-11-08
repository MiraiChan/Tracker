//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Almira Khafizova on 06.11.23.
//

import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    
    func didTrackerAdded(category: String, tracker: Tracker)
}

final class NewHabitViewController: UIViewController {
    
    private static let sectionName = 0
    private var categoryDelegate: CategoryViewController?


    private var buttonFirstCell = FirstCellButton()
    private var selectedCategory = ""
    
    
    private let buttonFirstIdentifier = "FirstCellButton"
    private let buttonSecondIdentifier = "SecondCellButton"
    
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headingLabel.text = "Новая привычка"
        return headingLabel
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.textColor = .gray
        textField.text = "Введите название трекера"
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.addTarget(self, action: #selector(editingDidBeginTextField(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndTextField(_:)), for: .editingDidEnd)
        return textField
    }()
    
    
    private lazy var cancelButton: UIButton = {
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let attributedString = NSAttributedString(
            string: "Отменить",
            attributes: [NSAttributedString.Key.font: font]
        )
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = nil
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 16
        button.titleLabel?.textColor = .red
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let font = UIFont.systemFont(ofSize: 19, weight: .medium)
        let attributedString = NSAttributedString(
            string: "Создать",
            attributes: [NSAttributedString.Key.font: font]
        )
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.titleLabel?.textColor = .white
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
     lazy var buttonTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
         tableView.backgroundColor = .ypBackgroundDay
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: tableView.bounds.height / 2, left: 15, bottom: tableView.bounds.height / 2, right: 15)
        tableView.register(FirstCellButton.self, forCellReuseIdentifier: buttonFirstIdentifier)
        tableView.register(SecondCellButton.self, forCellReuseIdentifier: buttonSecondIdentifier)
        return tableView
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewController()
    }
    
    private func settingsViewController() {

        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(headingLabel)
        scrollView.addSubview(nameTrackerTextField)
        scrollView.addSubview(buttonTableView)
        
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            headingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 52),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            buttonTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 20),
            buttonTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonTableView.heightAnchor.constraint(equalToConstant: 150),
            

            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    @objc private func editingDidBeginTextField(_ textField: UITextField) {
        if textField.text == "Введите название трекера" {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    @objc private func editingDidEndTextField(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.text = "Введите название трекера"
            textField.textColor = .gray
        }
    }
    
    @objc private func tapCancelButton() {
        dismiss(animated: true)
        print("tapCancelButton")
    }
    
    @objc private func tapCreateButton() {
        print("tapCreateButton")
    }
}
