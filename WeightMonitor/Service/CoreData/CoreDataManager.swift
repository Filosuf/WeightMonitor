//
//  CoreDataManager.swift
//  WeightMonitor
//
//  Created by Filosuf on 09.05.2023.
//

import Foundation
import CoreData

final class CoreDataManager {
    // MARK: - Properties
    let didChangeNotification = Notification.Name(rawValue: "ContextDidChange")

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weight")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    private var context: NSManagedObjectContext { persistentContainer.viewContext }

    // MARK: - Methods
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                post()
            } catch {
               let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func post() {
        NotificationCenter.default
            .post(
                name: didChangeNotification,
                object: self,
                userInfo: nil)
    }
}

// MARK: - NotepadDataStore
extension CoreDataManager: WeightDataStore {
    var notificationName: Notification.Name { didChangeNotification }
    var managedObjectContext: NSManagedObjectContext {
        context
    }

    func save(_ weight: WeightMeasurement) {
        let newWeightCoreData = fetchWeightMeasurement(weight: weight) ?? WeightCoreData(context: context)
        newWeightCoreData.weight = weight.weight
        newWeightCoreData.date = weight.date
        newWeightCoreData.id = weight.id
        saveContext()
    }

    func delete(_ weight: WeightMeasurement) {
        if let weightCoreData = fetchWeightMeasurement(weight: weight) {
            context.delete(weightCoreData)
            saveContext()
        }
    }

    func fetchWeightMeasurements() -> [WeightMeasurement] {
        let request = WeightCoreData.fetchRequest()
        guard let fetchRequestResult = try? context.fetch(request) else { return [] }
        var weightMeasurements = fetchRequestResult.map { $0.toWeightMeasurement() }
        weightMeasurements.sort{ $0.date > $1.date }
        return weightMeasurements
    }

    private func fetchWeightMeasurement(weight: WeightMeasurement) -> WeightCoreData? {
        let request = WeightCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", weight.id)
        return (try? context.fetch(request))?.first
    }
}
