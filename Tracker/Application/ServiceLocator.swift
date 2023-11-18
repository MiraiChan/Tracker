//
//  ServiceLocator.swift
//  Tracker
//
//  Created by Almira Khafizova on 08.11.23.
//

// Template Singleton (access to the storage of trackers)

import Foundation

struct ServiceLocator {
    
    static let instance = ServiceLocator()
    
    let trackerStorage: TrackersStorageProtocol
    
    private init() {
        trackerStorage = TrackersStorage.shared
    }
}
