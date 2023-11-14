//
//  TextInputCell.swift
//  Tracker
//
//  Created by Almira Khafizova on 07.11.23.
//

import UIKit

protocol TextInputCellDelegate: AnyObject {
    
    func didInputChanged(value: String)
}

final class TextInputCell: UICollectionViewCell & UITextFieldDelegate {
    
    private lazy var textField: UITextField = {
        //let textField = UIBuilder.getInputField()
        textField.addTarget(self, action: #selector(didTextChanged), for: .editingChanged)
        textField.delegate = self
        textField.placeholder = "Введите название трекера"
        return textField
    }()
    
    private weak var delegate: TextInputCellDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.contentView.endEditing(true)
        return false
    }
    
    // MARK: - public
    func setDelegate(delegate: TextInputCellDelegate) {
        self.delegate = delegate
    }
    
    func bind(item: Item) {
        textField.placeholder = item.placeholder
        textField.text = item.text
    }
    
    // MARK: - private
    @objc
    private func didTextChanged(sender: UITextField) {
        delegate?.didInputChanged(value: sender.text ?? "")
    }
    
    struct Item {
        var text: String
        var placeholder: String
    }
}

