//
//  EventColorCell.swift
//  Tracker
//
//  Created by Almira Khafizova on 23.11.23.
//

import UIKit

final class EventColorCell: UICollectionViewCell {
    
    static var reuseId = "Event color cell"
    
    private let colorViewSize: CGFloat = 40.0
    private let centerOffset: CGFloat = 2.0
    
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.frame = CGRect(
            x: (contentView.bounds.width - colorViewSize) / centerOffset,
            y: (contentView.bounds.height - colorViewSize) / centerOffset,
            width: colorViewSize,
            height: colorViewSize
        )
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
}
