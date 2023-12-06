//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Almira Khafizova on 06.12.23.
//

import UIKit
import CoreData

final class CategoryViewModel {
    
    static let shared = CategoryViewModel()
    private var categoryStore = TrackerCategoryStore.shared
    private (set) var categories: [TrackerCategory] = []
}
