//
//  WeightDataStore.swift
//  WeightMonitor
//
//  Created by Filosuf on 09.05.2023.
//

import Foundation
import CoreData

protocol WeightDataStore {
    // MARK: - Properties
    var notificationName: Notification.Name { get }

    // MARK: - Methods
    func fetchWeightMeasurements() -> [WeightMeasurement]
    func save(_ weight: WeightMeasurement)
    func delete(_ weight: WeightMeasurement)
}
