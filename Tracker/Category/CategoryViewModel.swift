//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Almira Khafizova on 06.12.23.
//

final class CategoryViewModel {
        
    static let shared = CategoryViewModel()
    private var categoryStore = TrackerCategoryStore.shared
    private (set) var categories: [TrackerCategory] = []
    
    @Observable
    private (set) var selectedCategory: TrackerCategory?
    
    init() {
        categoryStore.delegate = self
        self.categories = categoryStore.trackerCategories
    }
    
    func addCategory(_ toAdd: String) {
        try? self.categoryStore.addNewCategory(TrackerCategory(title: toAdd, trackers: []))
    }
    
    func addTrackerToCategory(to title: String?, tracker: Tracker) {
        try? self.categoryStore.addTrackerToCategory(to: title, tracker: tracker)
    }
    
    func selectCategory(_ at: Int) {
        self.selectedCategory = self.categories[at]
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func storeCategory() {
        self.categories = categoryStore.trackerCategories
    }
}
