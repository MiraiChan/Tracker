//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Almira Khafizova on 02.11.23.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func didTrackerAdded (category: String, tracker: Tracker)
}

final class NewTrackerViewController: UIViewController {
    
    private weak var delegate: NewTrackerViewControllerDelegate? = nil
    
    convenience init(delegate: NewTrackerViewControllerDelegate) {
        self.init(nibName: nil, bundle: Bundle.main)
        self.delegate = delegate
    }
    
    lazy private var pageTitleLabel = UILabel()
    lazy private var createHabitButton = UIButton()
    lazy private var createIrregularEventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllerUISetup()
    }
}

private extension NewTrackerViewController {
    func viewControllerUISetup() {
        view.backgroundColor = .white
        
        setupPageTitleLabel()
        
        setupCreateHabitButton()
        setupIrregularEventButton()
    }
    
    func setupPageTitleLabel() {
        let title = pageTitleLabel
        
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        title.text = "Создание трекера"
        
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupCreateHabitButton() {
        let habitButton = createHabitButton
        
        habitButton.backgroundColor = .black
        habitButton.layer.cornerRadius = 16
        
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        habitButton.addTarget(self, action: #selector(newHabitActionButton), for: .touchUpInside)
        
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitButton)
        
        NSLayoutConstraint.activate([
            habitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 395),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupIrregularEventButton() {
        let eventButton = createIrregularEventButton
        
        eventButton.backgroundColor = .black
        eventButton.layer.cornerRadius = 16
        
        eventButton.setTitle("Нерегулируемое событие", for: .normal)
        eventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        eventButton.addTarget(self, action: #selector(irregularEvenActionButton), for: .touchUpInside)
        
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventButton)
        
        NSLayoutConstraint.activate([
            eventButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 471),
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @IBAction func newHabitActionButton() {
        let newHabitViewController = NewHabitViewController()
        self.present(newHabitViewController, animated: true, completion: nil)
    }
    
    @IBAction func irregularEvenActionButton() {
        let irregularEventViewController = IrregularEventViewController()
        self.present(irregularEventViewController, animated: true, completion: nil)
    }
    
    @objc
    private func didHabitButtonTapped() {
        //showNewTrackerViewController(isHabit: true)
    }
    
    @objc
    private func didEventButtonTapped() {
    }
}

extension NewTrackerViewController: NewTrackerViewControllerDelegate {
    
    func didTrackerAdded(category: String, tracker: Tracker) {
        dismiss(animated: true) { [weak delegate] in
            delegate?.didTrackerAdded (category: category, tracker: tracker)
        }
    }
}
