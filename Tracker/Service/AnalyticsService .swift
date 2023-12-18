//
//  AnalyticsService .swift
//  Tracker
//
//  Created by Almira Khafizova on 14.12.23.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "4f5Dad68ab-7c0e-46b2-84ac-4139bf438c20") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(_ event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
