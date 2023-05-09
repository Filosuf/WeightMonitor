//
//  WeightDataStore.swift
//  WeightMonitor
//
//  Created by Filosuf on 09.05.2023.
//

import Foundation
import CoreData

protocol WeightDataStore {
    var managedObjectContext: NSManagedObjectContext { get }
    var notificationName: Notification.Name { get }

    func fetchWeightMeasurements() -> [WeightMeasurement]
    func save(_ weight: WeightMeasurement)
    func delete(_ weight: WeightMeasurement)
}
