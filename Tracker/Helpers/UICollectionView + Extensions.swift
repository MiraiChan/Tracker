//
//  UICollectionView + Extensions.swift
//  Tracker
//
//  Created by Almira Khafizova on 07.11.23.
//

import UIKit

extension UICollectionView {
    
    //a convenient way to retrieve a reusable cell from a collection
    func dequeueReusableCellWithType<T : UICollectionViewCell>(
        _ cellClass: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("Failed to dequeue a cell of type \(cellClass))")
        }
        return cell
    }
    
    func registerCell(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}

extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
